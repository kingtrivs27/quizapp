class Api::V1::UsersController < Api::ApiController
  skip_before_filter :authenticate, only: [:register]

  def register
    response = {}
    if params[:user].blank?
      render json: {
        status: false,
        error: "Invalid params"
      } and return
    end

    @user = User.find_by(user_name: user_params[:user_name])
    # device_exists = Device.where(user_device_id: device_params[:user_device_id]).exists?

    if @user.present?
      if @user.devices.create(device_params)
        response[:status] = true
        response[:api_key] = @user.api_key
        response[:error] = nil
      else
        response[:status] = false
        response[:error] = {code: 0, message: 'User added, but Failed to create device information'}
      end
      render json: response and return
    end

    render json: response
  end

    private
    def user_params
      {
        user_name: json_params[:user][:user_name],
        email: json_params[:user][:email]
      }
    end

    def device_params
      return json_params.require(:device_info).permit(:user_device_id, :google_api_key, :android_id, :serial_number, :model, :board, :brand, :device, :hardware, :manufacturer, :product, :android_os)
    end

end
