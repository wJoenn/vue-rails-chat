require "rails_helper"

def log_in(email)
  post :create, format: :json, params: { user: { email:, password: user.password } }
end

def log_out
  delete :destroy, format: :json
end

RSpec.describe Users::SessionsController, type: :controller do
  describe "#respond_with" do
    let!(:user) { User.create(email: "user@example.com", password: "password") }

    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "responds with a JSON object" do
      log_in(user.email)

      expect(response.body.class).to eq(String)
      expect(response.parsed_body.class).to eq(Hash)

      log_in("wrong email")

      expect(response.body.class).to eq(String)
      expect(response.parsed_body.class).to eq(Hash)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      log_out

      expect(response.body.class).to eq(String)
      expect(response.parsed_body.class).to eq(Hash)

      log_out

      expect(response.body.class).to eq(String)
      expect(response.parsed_body.class).to eq(Hash)
    end

    context "When user is logged in sucessfuly" do
      before do
        log_in(user.email)
      end

      it "responds with the logged in user and a success message" do
        expect(response.parsed_body.key?("user")).to eq(true)
        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to eq("You are logged in.")
      end

      it "responds with a status code of 200" do
        expect(response).to be_successful
      end
    end

    context "When user is not logged in successfuly" do
      before do
        log_in("wrong email")
        get :new, format: :json if response.status == 401
      end

      it "responds with an error message" do
        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to eq("Invalid Email or Password.")
      end

      it "responds with a status code of 400" do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context "When user is logged out successfully" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        log_out
      end

      it "responds with a success message" do
        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to eq("You are logged out.")
      end

      it "responds with a status code of 200" do
        expect(response).to be_successful
      end
    end

    context "When user is not logged out successfully" do
      before do
        log_out
      end

      it "responds with a success message" do
        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to eq("Hmm nothing happened.")
      end

      it "responds with a status code of 404" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
