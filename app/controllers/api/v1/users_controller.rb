class Api::V1::UsersController < Api::ApiController
  skip_before_filter :authenticate, only: [:register]

  # todo
  # error and exception handling
  def register
    data = {}
    if params[:user].blank?
      render json: get_v1_formatted_response({}, false, ['Invalid params']).to_json and return
    end

    User.transaction do
      user = User.find_by(email: user_params[:email])
      user = User.create(name: user_params[:user_name], email: user_params[:email], facebook_id: user_params[:facebook_id]) if user.blank?

      device = Device.where(user_device_id: device_params[:user_device_id]).first

      device.present? ?
        device.update_attributes(device_params.merge(user_id: user.id)) :
        user.devices.create!(device_params)

      data = {access_token: user.api_key}
    end

    render json: get_v1_formatted_response(data, true, ['Successfully registered']).to_json

  rescue Exception => e
    #todo use exception notifier for emailing the admins

    log_errors(e)
    render json: get_v1_formatted_response({}, false, ['Failed to register! please try again later']).to_json
  end


  def get_user
    response = {}
    user = User.select(:id, :name, :email, :phone, :city).where(api_key: params[:access_token]).first
    # todo add error messages as needed

    if user.present?
      response = get_v1_formatted_response({user: user.attributes}, true, [])
    else
      response = get_v1_formatted_response({}, false, ['User not found'])
    end

    render json: response.to_json
  end


  def update_device_info
    update_successful = true
    update_message = 'successfully updated'

    # get the user and device
    user = User.find_by(api_key: params[:access_token])
    device = user.devices.where(user_device_id: params[:device_info][:device_id]).first if user.present?

    if device.present?
      device.update_attributes(device_params)
    else
      update_successful = false
      update_message = 'user device not found'
    end
    render json: get_v1_formatted_response({}, update_successful, [update_message]).to_json
  end

  # def get_info_by_email
  #   user = User.find_by(email: params[:email])
  #
  #   if user.present?
  #     response = user.attributes
  #     user.devices
  #
  #     render json: get_v1_formatted_response(response, true, ['user not found']).to_json
  #   else
  #     render json: get_v1_formatted_response({}, false, ['user not found']).to_json
  #   end
  #
  # end


  private
  def user_params
    {
      user_name: params[:user][:user_name],
      email: params[:user][:email],
      facebook_id: params[:user][:facebook_id]
    }
  end

  def device_params
    # todo generating it for now
    params[:device_info][:google_api_key] = params[:device_info][:gcm_key]

    # params.require(:device_info).permit(:user_device_id, :google_api_key, :android_id, :serial_number, :model, :board, :brand, :device, :hardware, :manufacturer, :product, :android_os)
    params.require(:device_info).permit(:user_device_id, :google_api_key, :android_id, :serial_number)
  end

end
