  class Api::V1::UsersController < Api::ApiController
  skip_before_filter :authenticate, only: [:register]

  # todo
  # currently handling use case of completely new users
  # error and exception handling
  def register
    response = {}
    if params[:user].blank?
      render json: {
        status: false,
        error: "Invalid params"
      } and return
    end

    User.transaction do
      user = User.find_by(name: user_params[:user_name])

      user = User.create(name: user_params[:user_name], email:user_params[:email]) if user.blank?
      # device_exists = Device.where(user_device_id: device_params[:user_device_id]).exists?

      if user.present?
        if user.devices.create(device_params)
          response[:status] = true
          response[:api_key] = user.api_key
          response[:error] = nil
        else
          response[:status] = false
          response[:error] = {code: 0, message: 'User added, but Failed to create device information'}
        end
      end
    end

    render json: response
  end

  def get_user
    @current_user ||= User.find_by_api_key(params[:access_token])
    render json: @current_user.to_json
  end









  private
  def user_params
    {
      user_name: params[:user][:user_name],
      email: params[:user][:email]
    }
  end

  def device_params
    # params.require(:device_info).permit(:user_device_id, :google_api_key, :android_id, :serial_number, :model, :board, :brand, :device, :hardware, :manufacturer, :product, :android_os)
    params.require(:device_info).permit(:user_device_id, :google_api_key, :android_id, :serial_number)
  end

end
