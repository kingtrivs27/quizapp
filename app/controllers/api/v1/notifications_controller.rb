class Api::V1::NotificationsController < Api::ApiController
  include Api::V1::NotificationsHelper

  def test_notify
    send_notification(params[:test_gcm_ids], [:test_payload_to_send])

    render json: get_v1_formatted_response({}, true, ['Notification sent!']).to_json
  end

  def send_quiz_question_and_scores

  end
end
