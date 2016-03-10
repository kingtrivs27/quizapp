class Api::ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token
  # before_action :return_error

  # todo enable authentication
  # before_action :authenticate

  before_action :set_default_response_format
  # before_action :update_user_apk_version
  # before_action :verify_blocked_user

  after_filter  :log_response

  # def return_error
  #   return if params[:action] == 'process_callback'
  #   render json: { status: false,
  #                  error: {code:    1001,
  #                          message: 'Service is temporarily down.'}} and return if request.headers['Apk-Version'].to_i < 15
  # end

  def log_response
    Rails.logger.info { "------------- Response: #{response.body.inspect} ------------" }
  end

  private

  def authenticate
    puts "-----------------------------------------authenticating request :"
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, _options|
      @current_user = User.find_by(api_key: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end

  def set_default_response_format
    request.format = :json
  end

  def get_v1_formatted_response(data, is_successful = false, messages = [])
    {
      success: is_successful,
      messages: [] + messages,
      data: {}.merge(data),
      version: "1.0.0"
    }
  end

  def log_errors(e)
    logger.error 'Error Message => ' + e.message
    logger.error 'Error Backtrace => ' + e.backtrace.join("\n")
  end

  # def update_user_apk_version
  #   apk_version = request.headers['Apk-Version'].to_i
  #   return if @current_user.blank? || @current_user.apk_version == apk_version
  #   @current_user.apk_version = apk_version
  #   @current_user.save!
  # end

  # def verify_blocked_user
  #   render json: { status: false,
  #                  error: {code:    101,
  #                          message: I18n.t('user.blocked')}} if @current_user.present? && @current_user.blocked?
  # end

end
