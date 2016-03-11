class Api::V1::SubjectsController < Api::ApiController
  require 'csv'

  def get_subjects
  #   todo check is current user is there using the access token

    all_subjects = Subject.select(:id, :name).all
    render json: get_v1_formatted_response({all_subjects: all_subjects}, true, [])
  end

  def import_questions_from_csv

    csv_file_path = File.join(Rails.root, 'app', 'csv', 'questions.csv')
    csv_file = File.open(csv_file_path, "r:ISO-8859-1")
    csv = CSV.parse(csv_file, :headers => true)

    create_test_students_params, noisy_data = [], []
    #60,000
    csv.each do |csv_row|
      formatted_csv_row = {
        subject_name: csv_row['subject_name'].to_s.strip,
        subject_id_in_db: csv_row['subject_id_in_db'].to_s.strip,
        question_desc: csv_row['question_desc'].to_s.strip,
        correct_option:csv_row['correct_option'.to_s.strip],
        option_a: csv_row['option_a'].to_s.strip,
        option_b: csv_row['option_b'].to_s.strip,
        option_c: csv_row['option_c'].to_s.strip,
        option_d: csv_row['option_d'].to_s.strip,
        option_e: csv_row['option_e'].to_s.strip
      }
      ActiveRecord::Base.transaction do
        subject = Subject.find_by(name: formatted_csv_row[:subject_name])
        if subject.blank?
          subject = Subject.create({name: formatted_csv_row[:subject_name]})
        end

        question_params = {description: formatted_csv_row[:question_desc], subject_id: subject.id}
        question = Question.create(question_params)

        answer_option_params = []

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_a],
          is_correct: formatted_csv_row[:correct_option] == 'a'
        } if formatted_csv_row[:option_a]

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_b],
          is_correct: formatted_csv_row[:correct_option] == 'b'
        } if formatted_csv_row[:option_b]

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_c],
          is_correct: formatted_csv_row[:correct_option] == 'c'
        } if formatted_csv_row[:option_c]

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_d],
          is_correct: formatted_csv_row[:correct_option] == 'd'
        } if formatted_csv_row[:option_d]

        answer_option_params << {
          question_id: question.id,
          description: formatted_csv_row[:option_e],
          is_correct: formatted_csv_row[:correct_option] == 'e'
        } if formatted_csv_row[:option_e]

        AnswerOption.create(answer_option_params)
      end
    end

    render json: get_v1_formatted_response({}, true, ['success'])

  end
end