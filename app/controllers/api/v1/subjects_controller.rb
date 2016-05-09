class Api::V1::SubjectsController < Api::ApiController

  skip_before_filter :authenticate, only: [:import_questions_from_csv]

  require 'csv'

  def get_subjects
  #   todo check is current user is there using the access token

    all_subjects = Subject.select(:id, :name).all
    render json: get_v1_formatted_response({all_subjects: all_subjects}, true, [])
  end

  def get_subjects_v2
    db_courses = Course.all.sort_by &:name
    db_subject_parents = SubjectParent.all.sort_by(&:name).group_by(&:course_id)
    db_subjects = Subject.all.sort_by(&:name).group_by(&:subject_parent_id)


    response = {}
    data = {}
    course_parents = []
    courses = {}

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

      courses[course.course_parent] ||= []

      courses[course.course_parent] << {
        id: course.id,
        name: course.name,
        subjects: subjects
      }
    end

    Course.course_parents.each_pair do |course_parent_name, course_parent_id|
      course_parents << {
        id: course_parent_id,
        name: course_parent_name.upcase,
        courses: courses[course_parent_name]
      }
    end

    response  = get_v1_formatted_response({course_parents: course_parents}, true, [''])

    render json: response.to_json
  end

  def import_questions_from_csv
    course_file = params[:course_file]

    csv_file_path = File.join(Rails.root, 'app', 'csv', course_file+'.csv')
    csv_file = File.open(csv_file_path, "r:utf-8")
    csv = CSV.parse(csv_file, :headers => true)
    a=0
    csv.each do |csv_row|
      a+=1
      formatted_csv_row = {
        course_parent: csv_row['course_parent'].to_s.strip,
        course_name: csv_row['course_name'].to_s.strip,
        subject_name: csv_row['subject_name'].to_s.strip,
        topic_name: csv_row['chapter_name'].to_s.strip,
        question_desc: ActionController::Base.helpers.strip_tags(csv_row['question_desc'].to_s.strip),
        correct_option:csv_row['correct_option'.to_s.strip],
        difficulty_level:csv_row['difficulty_level'.to_s.strip],
        option_a: ActionController::Base.helpers.strip_tags(csv_row['option_a'].to_s.strip),
        option_b: ActionController::Base.helpers.strip_tags(csv_row['option_b'].to_s.strip),
        option_c: ActionController::Base.helpers.strip_tags(csv_row['option_c'].to_s.strip),
        option_d: ActionController::Base.helpers.strip_tags(csv_row['option_d'].to_s.strip)
      }

      # ignore invalid row
      next if !is_valid_row?(formatted_csv_row)
      p " **** "
      p "---- PROCESSING ROW ---- "+a.to_s
      p " **** "

      ActiveRecord::Base.transaction do
        course = Course.find_by(name: formatted_csv_row[:course_name])
        course_parent = Course.course_parents[formatted_csv_row[:course_parent]]
        raise "Illegal course parent #{formatted_csv_row[:course_parent]} in data." if course_parent.blank?

        if course.blank?
          course = Course.create({name: formatted_csv_row[:course_name], course_parent: course_parent})
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
          is_correct: formatted_csv_row[:correct_option] == '1' || formatted_csv_row[:correct_option] == 'a'
        }

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_b],
          is_correct: formatted_csv_row[:correct_option] == '2' || formatted_csv_row[:correct_option] == 'b'
        }

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_c],
          is_correct: formatted_csv_row[:correct_option] == '3' || formatted_csv_row[:correct_option] == 'c'
        }

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_d],
          is_correct: formatted_csv_row[:correct_option] == '4' || formatted_csv_row[:correct_option] == 'd'
        }

        AnswerOption.create(answer_option_params)

        # csv_row.is_imported = 1
      end
    end

    render json: get_v1_formatted_response({}, true, ['success'])

  end

  private
  def is_valid_row?(formatted_csv_row)
    formatted_csv_row[:course_parent].present? &&
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