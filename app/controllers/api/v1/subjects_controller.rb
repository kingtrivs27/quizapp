class Api::V1::SubjectsController < Api::ApiController

  skip_before_filter :authenticate, only: [:import_questions_from_csv]

  require 'csv'

  def get_subjects
  #   todo check is current user is there using the access token

    all_subjects = Subject.select(:id, :name).all
    render json: get_v1_formatted_response({all_subjects: all_subjects}, true, [])
  end

  def get_subjects_v2
    db_courses = Course.all
    db_subject_parents = SubjectParent.all.group_by(&:course_id)
    db_subjects = Subject.all.group_by(&:subject_parent_id)


    response = {}
    data = {}
    data[:courses] = []

    db_courses.each do |course|
      subjects = []

      db_subject_parents[course.id].each do |subject_parent|
        topics = []

        db_subjects[subject_parent.id].each do |subject|
          topics << {
            id: subject.id,
            name: subject.name
          }
        end

        subjects << {
          id: subject_parent.id,
          name: subject_parent.name,
          topics: topics
        }
      end

      data[:courses] << {
        id: course.id,
        name: course.name,
        subjects: subjects
      }
    end

    response  = get_v1_formatted_response(data, true, [''])

    render json: response.to_json
  end

  def import_questions_from_csv
    course_file = params[:course_file]

    csv_file_path = File.join(Rails.root, 'app', 'csv', course_file+'.csv')
    csv_file = File.open(csv_file_path, "r:ISO-8859-1")
    csv = CSV.parse(csv_file, :headers => true)

    csv.each do |csv_row|
      formatted_csv_row = {
        course_name: csv_row['course_name'].to_s.strip,
        subject_name: csv_row['subject_name'].to_s.strip,
        topic_name: csv_row['chapter_name'].to_s.strip,
        question_desc: csv_row['question_desc'].to_s.strip,
        correct_option:csv_row['correct_option'.to_s.strip],
        difficulty_level:csv_row['difficulty_level'.to_s.strip],
        option_a: csv_row['option_a'].to_s.strip,
        option_b: csv_row['option_b'].to_s.strip,
        option_c: csv_row['option_c'].to_s.strip,
        option_d: csv_row['option_d'].to_s.strip
      }

      # ignore invalid row
      next if !is_valid_row?(formatted_csv_row)

      ActiveRecord::Base.transaction do
        course = Course.find_by(name: formatted_csv_row[:course_name])
        if course.blank?
          course = Course.create({name: formatted_csv_row[:course_name]})
        end

        # Subject as per UI
        subject_parent = SubjectParent.find_by(name: formatted_csv_row[:subject_name], course_id: course.id)
        if subject_parent.blank?
          subject_parent = SubjectParent.create({name: formatted_csv_row[:subject_name], course_id: course.id})
        end

        # Topic as per UI
        subject = Subject.find_by(name: formatted_csv_row[:topic_name], subject_parent_id: subject_parent.id)
        if subject.blank?
          subject = Subject.create({name: formatted_csv_row[:topic_name], subject_parent_id: subject_parent.id})
        end

        question_params = {description: formatted_csv_row[:question_desc],
                           subject_id: subject.id, level:
                           formatted_csv_row[:difficulty_level]}
        question = Question.create(question_params)

        answer_option_params = []

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_a],
          is_correct: formatted_csv_row[:correct_option] == '1'
        }

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_b],
          is_correct: formatted_csv_row[:correct_option] == '2'
        }

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_c],
          is_correct: formatted_csv_row[:correct_option] == '3'
        }

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_d],
          is_correct: formatted_csv_row[:correct_option] == '4'
        }

        AnswerOption.create(answer_option_params)

        # csv_row.is_imported = 1
      end
    end

    render json: get_v1_formatted_response({}, true, ['success'])

  end

  private
  def is_valid_row?(formatted_csv_row)
    formatted_csv_row[:course_name].present? &&
    formatted_csv_row[:topic_name].present? &&
    formatted_csv_row[:subject_name].present? &&
    formatted_csv_row[:question_desc].present? &&
    formatted_csv_row[:correct_option].present? &&
    formatted_csv_row[:option_a].present? &&
    formatted_csv_row[:option_b].present? &&
    formatted_csv_row[:option_c].present? &&
    formatted_csv_row[:option_d].present? &&
    formatted_csv_row[:difficulty_level].present?
  end
end