class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    return register_success if resource.persisted?

    if resource.errors.any?
      message = resource.errors.full_messages
    else
      message = "Something went wrong."
    end

    register_failed(message)
  end

  def register_success
    render json: {
      message: "Signed up successfully.",
      user: current_user
    }, status: :ok
  end

  def register_failed(message)
    render json: { message: }, status: :unprocessable_entity
  end
end
