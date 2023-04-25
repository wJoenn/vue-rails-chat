class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def set_flash_message(_key, _kind, _options); end

  def respond_with(_resource, _opts = {})
    return log_in_success if current_user

    log_in_failure
  end

  def log_in_success
    render json: {
      message: "You are logged in.",
      user: current_user
    }, status: :ok
  end

  def log_in_failure
    render json: {
      message: "Invalid Email or Password."
    }, status: :unprocessable_entity
  end

  def respond_to_on_destroy
    return log_out_success if current_user

    log_out_failure
  end

  def log_out_success
    render json: {
      message: "You are logged out."
    }, status: :ok
  end

  def log_out_failure
    render json: {
      message: "Hmm nothing happened."
    }, status: :not_found
  end
end
