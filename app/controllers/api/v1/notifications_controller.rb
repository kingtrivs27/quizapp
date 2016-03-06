class Api::V1::NotificationsController < Api::ApiController
  include Api::V1::NotificationsHelper

  def test_notify
    gcm_response = send_notification(params[:test_gcm_ids], params[:test_payload_to_send])

    render json: get_v1_formatted_response({}, true, [gcm_response[:response]]).to_json
  end

  def send_quiz_question_and_scores

  end
end
