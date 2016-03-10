class BaseService
  def log_errors(e)
    Rails.logger.error 'Error Message => ' + e.message
    Rails.logger.error 'Error Backtrace => ' + e.backtrace.join("\n")
  end
end