class Api::V1::QuizesController < Api::ApiController
  def quiz_request
    requested_subject_id = params[:subject_id]
    current_user = User.find_by(api_key: params[:access_token])

    # TODO::Avoid race contion in future for this request
    pending_request = Quiz.where(subject_id: requested_subject_id).pending.limit(1).first
    quiz_service = QuizService.new(current_user)

    if pending_request.present?
      quiz_response = quiz_service.add_as_opponent(pending_request)
    else
      quiz_response = quiz_service.create_pending_quiz(quiz_params)
    end

    if quiz_response[:success]
      response_hash = get_v1_formatted_response(quiz_response[:data], is_successful = true, messages = ['Waiting for a match'])
    else
      response_hash = get_v1_formatted_response(quiz_response[:data], is_successful = false, messages = quiz_response[:errors])
    end
    render json: response_hash.to_json
  end

  private
  def quiz_params
    params.permit(:subject_id)
  end
end
