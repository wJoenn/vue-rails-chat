require "rails_helper"

RSpec.describe "Chatrooms", type: :request do
  describe "GET /index" do
    let!(:user) { User.create(email: "user@example.com", password: "password", username: "Joenn") }

    before(:each) do
      Chatroom.create(name: "general")
      Chatroom.create(name: "nsfw")
    end

    context "When user is not logged in" do
      before do
        get "/chatrooms"
      end

      it "returns http status 302" do
        expect(response).to have_http_status(:found)
      end
    end

    context "When user is logged in" do
      before do
        post "/users/sign_in",
          params: { user: { email: user.email, password: user.password } }.to_json,
          headers: { "Content-Type": "application/json" },
          env: { "devise.mapping": Devise.mappings[:user] }

        get "/chatrooms"
      end

      it "returns a list of Chatrooms" do
        list = response.parsed_body
        expect(list.length).to eq(2)

        list = list.pluck("name")
        expect(list.first).to eq("general")
        expect(list.last).to eq("nsfw")
      end

      it "returns http status 200" do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
