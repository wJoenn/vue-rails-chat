require "rails_helper"

RSpec.describe "Members", type: :request do
  describe "GET /show" do
    let(:user) { User.create!(email: "user@example.com", password: "password", username: "Joenn") }
    let(:jwt_token) do
      token = {
        sub: user.id,
        scp: "user",
        aud: nil,
        iat: Time.current.to_i,
        exp: 1.month.from_now.to_i,
        jti: SecureRandom.uuid
      }

      JWT.encode(token, Rails.application.credentials.devise[:jwt_secret_key])
    end

    context "When user is logged in" do
      it "returns a success response" do
        get "/member-data", headers: { Authorization: "Bearer #{jwt_token}" }

        expect(response).to be_successful
        expect(response.parsed_body["message"]).to eq("If you see this you're logged in")
      end
    end

    context "When user is not logged in" do
      before do
        user.destroy
      end

      it "returns an error response" do
        get "/member-data", headers: { Authorization: "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body["message"]).to eq("Your JWT token was linked to a deleted user account")
      end
    end
  end
end
