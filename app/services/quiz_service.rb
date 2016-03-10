class QuizService < BaseService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def add_as_opponent(pending_request)
    errors, quiz_data = [], {}


    begin
      if pending_request.requester_id != user.id
        pending_request.update_attributes!(opponent_id: user.id)
      end

      question_ids_json = pending_request.info
      question_ids = JSON.parse(question_ids_json)

      selected_questions = Question.where(id: question_ids)
      selected_question_ids = selected_questions.collect{ |q| q.id }

      quiz_id = pending_request.id
      quiz_data = get_quiz_response(selected_questions, selected_question_ids)
      quiz_data.merge!(quiz_id: quiz_id)

    rescue Exception => e
      log_errors(e)
      errors << 'Something went wrong, please contact support team.'
    end

    return {success: errors.blank?, errors: errors, data: quiz_data }
  end

  def create_pending_quiz(quiz_params)
    quiz_id, errors, selected_question_ids = nil, [], []
    subject_id = quiz_params[:subject_id]

    # choose random 10 questions
    selected_questions = Question.where(subject_id: subject_id).sample(10)
    selected_question_ids = selected_questions.collect{ |q| q.id }

    create_quiz_params = {
      subject_id: subject_id,
      requester_id: user.id,
      info: selected_question_ids.to_json
    }

    begin
      quiz_id = Quiz.create!(create_quiz_params)
      quiz_data = get_quiz_response(selected_questions, selected_question_ids)
      quiz_data.merge!(quiz_id: quiz_id)

    rescue Exception => e
      log_errors(e)
      errors << 'Something went wrong, please contact support team.'
    end

    return {success: errors.blank?, errors: errors, data: quiz_data }
  end

  def get_quiz_response(selected_questions, selected_question_ids)
    all_answers_by_question_ids = AnswerOption.where(question_id: selected_question_ids).group_by(&:question_id)

    questions = []
    selected_questions.each do |question|
      options, correct_option_id = [], nil

      (all_answers_by_question_ids[question.id] || []).each do |option|
        options << {
          id: option.id,
          text: option.description
        }
        correct_option_id = option.id if option.is_correct
      end
      questions << {
        question_id: question.id,
        description: question.description,
        type: 'radio',
        options: options,
        correct_option_id: correct_option_id
      }
    end

    quiz_data = {
      questions: questions,
      total_questions: questions.length
    }

    return quiz_data
  end
end


