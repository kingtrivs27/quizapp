class Api::V1::QuizesController < Api::ApiController
  def quiz_request
    requested_subject_id = params[:subject_id]

    # TODO::Avodi race contion in future for this request
    pending_request = Quiz.where(subject_id: requested_subject_id).pending.limit(1).first

    quiz_service = QuizService.new(@current_user)
    if pending_request.present?
      quiz_service.add_as_opponent(quiz_params)
    else
      quiz_response = quiz_service.create_pending_quiz(quiz_params)

    end

    if quiz_response[:success]
      get_v1_formatted_response(data, is_successful = true, messages = [])
    else
      get_v1_formatted_response(data, is_successful = false, messages = [])
    end
  end

  private
  def quiz_params
    params.permit(:subject_id)
  end
end
