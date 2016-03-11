class Api::V1::QuizesController < Api::ApiController
  include Api::V1::NotificationsHelper

  def quiz_request
    requested_subject_id = params[:subject_id]
    current_user = User.find_by(api_key: params[:access_token])
    quiz_response = {}

    ActiveRecord::Base.transaction do
      # TODO::Avoid race condition in future for this request
      pending_request = Quiz.where(subject_id: requested_subject_id).pending.limit(1).first
      quiz_service = QuizService.new(current_user)

      if pending_request.present?
        quiz_response = quiz_service.add_as_opponent(pending_request)
        if quiz_response[:success]
          # send notification to both users
          first_user_payload = {opponent: {
            name: current_user.name ,
            location: current_user.city,
            image_url: current_user.image_url}
          }

          first_user = User.find_by(id: pending_request.requester_id)
          second_user_payload = {opponent: {
            name: first_user.name ,
            location: first_user.city,
            image_url: first_user.image_url}
          }

          gcm_response = send_notification(second_user_payload, current_user.devices.collect(&:user_device))
          gcm_response = send_notification(first_user_payload, first_user.devices.collect(&:user_device))

        end
      else
        quiz_response = quiz_service.create_pending_quiz(quiz_params)
      end
    end

    if quiz_response[:success]
      response_hash = get_v1_formatted_response(quiz_response[:data], is_successful = true, messages = ['Waiting for a match'])
    else
      response_hash = get_v1_formatted_response(quiz_response[:data], is_successful = false, messages = quiz_response[:errors])
    end

    render json: response_hash.to_json and return
  rescue Exception => e
    log_errors(e)
    render json: get_v1_formatted_response({}, false, ['Failed to make a quiz request! please try again later']).to_json
  end


  def submit_answer
    @current_user = User.find_by(api_key: params[:access_token])
    params[:current_user_id] = @current_user.id

    answer_flag = params[:flag]
    send_gcm = false
    quiz = Quiz.find_by(id: params[:quiz_id])

    ActiveRecord::Base.transaction do
      if answer_flag == 'answer_submit'
        send_gcm = quiz.handle_answer_submit(params)

      elsif answer_flag == 'timeout'
        send_gcm = quiz.handle_answer_timeout(params)

      elsif answer_flag == 'user_quit'
        send_gcm = handle_user_quit(params)
      end
    end

    # todo check if quiz reload is needed
    send_notification_for_next_question(quiz, params) if send_gcm

    render json: get_v1_formatted_response({}, true, ['success']).to_json and return

  rescue Exception => e
    log_errors(e)
    render json: get_v1_formatted_response({}, false, ['failed to submit answer']).to_json
  end

  private
  def quiz_params
    params.permit(:subject_id)
  end


  def send_notification_for_next_question(quiz, params)
    available_user_ids = quiz.get_available_user_ids

    gcm_device_ids = []
    devices = Device.select(:user_device_id).where(user_id: [1,3])
    devices.each do |device|
      gcm_device_ids << device.user_device_id if device.user_device_id.present?
    end
    binding.pry
    if gcm_device_ids.present?
      payload = quiz.get_next_question_gcm_payload(params)

      send_notification(payload, gcm_device_ids)
    end
  end
end