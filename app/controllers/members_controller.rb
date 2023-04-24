class MembersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    user = set_user_from_token

    if user
      render json: {
        message: "If you see this you're logged in",
        user:
      }, status: :ok
    else
      jwt_payload = set_jwt_payload
      jti = jwt_payload["jti"]
      exp = Time.zone.at(jwt_payload["exp"]).to_datetime

      JwtDenylist.create(jti:, exp:)

      render json: {
        message: "Your JWT token was linked to a deleted user account"
      }, status: :unprocessable_entity
    end
  end

  private

  def set_user_from_token
    jwt_payload = set_jwt_payload

    user_id = jwt_payload["sub"]

    User.find_by(id: user_id)
  end

  def set_jwt_payload
    JWT.decode(request.headers["Authorization"].split[1],
      Rails.application.credentials.devise[:jwt_secret_key]).first
  end
end
