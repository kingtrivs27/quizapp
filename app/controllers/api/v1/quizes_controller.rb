class Api::V1::QuizesController < Api::ApiController
  include Api::V1::NotificationsHelper

  def quiz_request
    requested_subject_id = params[:subject_id]
    current_user = @current_user || User.find_by(api_key: params[:access_token])
    quiz_response = {}


    # TODO::Avoid race condition in future for this request
    pending_request = Quiz.where(subject_id: requested_subject_id).pending.limit(1).first
    quiz_service = QuizService.new(current_user)

    if pending_request.present?
      if params[:mode] == 'bot'

        ActiveRecord::Base.transaction do
          pending_request.update_attributes({opponent_type: 1, status: 1, opponent_id: 0, requester_waiting: false })
        end

        first_user_payload = {
          type: 'QUIZ_START',
          name: 'Bot' ,
          facebook_id: 0
        }

        gcm_response = send_notification(first_user_payload, Device.where(user_id: current_user.id).pluck(:google_api_key))
        Rails.logger.info("##########################################")
        Rails.logger.info(gcm_response)
        Rails.logger.info("##########################################")
      else
        ActiveRecord::Base.transaction do
          quiz_response = quiz_service.add_as_opponent(pending_request)

          if quiz_response[:success]
            pending_request.status = Quiz.statuses[:started]
            pending_request.save
          end
        end

        if quiz_response[:success]
          # send notification to both users
          first_user_payload = {
            type: 'QUIZ_START',
            name: current_user.name ,
            facebook_id: current_user.facebook_id
          }

          first_user = User.find_by(id: pending_request.requester_id)
          second_user_payload = {
            type: 'QUIZ_START',
            name: first_user.name,
            facebook_id: first_user.facebook_id
          }

          gcm_response = send_notification(second_user_payload, Device.where(user_id: current_user.id).pluck(:google_api_key))
          Rails.logger.info("##########################################")
          Rails.logger.info(gcm_response)
          Rails.logger.info("##########################################")

          gcm_response = send_notification(first_user_payload, Device.where(user_id: first_user.id).pluck(:google_api_key))
          Rails.logger.info("##########################################")
          Rails.logger.info(gcm_response)
          Rails.logger.info("##########################################")
        end
      end
    else
      ActiveRecord::Base.transaction do
        quiz_response = quiz_service.create_pending_quiz(quiz_params)
      end
    end

    if quiz_response[:success]
      response_hash = get_v1_formatted_response(quiz_response[:data], true, ['Waiting for a match'])
    else
      response_hash = get_v1_formatted_response(quiz_response[:data], true, quiz_response[:errors] || [])
    end

    render json: response_hash.to_json and return
  rescue Exception => e
    log_errors(e)
    render json: get_v1_formatted_response({}, false, ['Failed to make a quiz request! please try again later']).to_json
  end


  def submit_answer
    # @current_user = User.find_by(api_key: params[:access_token])
    @current_user ||= User.find_by(api_key: params[:access_token])
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
        send_gcm = quiz.handle_user_quit(params)
      end
    end

    # todo check if quiz reload is needed
    quiz.reload
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
    available_user_ids_by_type = quiz.available_user_ids_by_type
    available_user_ids = []
    available_user_ids << available_user_ids_by_type[:opponent_id] if available_user_ids_by_type[:opponent_id].present?
    available_user_ids << available_user_ids_by_type[:requester_id] if available_user_ids_by_type[:requester_id].present?

    gcm_device_ids = []
    opponent_gcm_keys = []
    requester_gcm_keys = []
    devices = Device.where(user_id: available_user_ids)
    devices.each do |device|
      if device.user_id == available_user_ids_by_type[:opponent_id]
        opponent_gcm_keys << device.google_api_key if device.google_api_key.present?
      elsif device.user_id == available_user_ids_by_type[:requester_id]
        requester_gcm_keys << device.google_api_key if device.google_api_key.present?
      end
    end

    if opponent_gcm_keys.present?
      payload = quiz.get_next_question_gcm_payload('opponent')

      Rails.logger.info("######### Next Question Gcm Payload opponent ########")
      Rails.logger.info(payload.inspect)

      send_notification(payload, opponent_gcm_keys)
    end

    if requester_gcm_keys.present?
      payload = quiz.get_next_question_gcm_payload('requester')

      Rails.logger.info("######### Next Question Gcm Payload ########")
      Rails.logger.info(payload.inspect)

      send_notification(payload, requester_gcm_keys)
    end


  end
end