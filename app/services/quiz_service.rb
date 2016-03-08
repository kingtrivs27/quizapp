class QuizService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def add_as_opponent

  end

  def create_pending_quiz(quiz_params)
    quiz_id, error, selected_question_ids = nil, [], []
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
    rescue
      error << 'Something went wrong, please contact support team.'
    end

    return {success: error.blank?, errors: errors, data: quiz_data }
  end

  def get_quiz_response(selected_questions, selected_question_ids)
    all_answers_by_question_ids = AnswerOption.where(question_id: selected_question_ids).group_by(&:question_id)

    questions = []
    selected_questions.each do |question|
      options, correct_option_id = [], nil
      all_answers_by_question_ids[question.id].each do |option|
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
        corect_option_id: all_answers_by_question_ids[:question.id],
        options: options,
        correct_option_id: correct_option_id
      }
    end

    quiz_data = {
      quesitons: questions,
      total_questions: questions.lenght
    }

    return quiz_data
  end
end


