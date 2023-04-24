require "rails_helper"

def create_user(params)
  post :create, format: :json, params:
end

RSpec.describe Users::RegistrationsController, type: :controller do
  describe "#respond_with" do
    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      @correct_user = { user: { email: "user@example.com", password: "password" } }
      @wrong_user = { user: { email: "user@example", password: "password" } }
    end

    it "responds with a JSON object" do
      create_user(@correct_user)

      expect(response.body.class).to eq(String)
      expect(response.parsed_body.class).to eq(Hash)

      create_user(@wrong_user)

      expect(response.body.class).to eq(String)
      expect(response.parsed_body.class).to eq(Hash)
    end

    context "When user is registered successfuly" do
      before do
        create_user(@correct_user)
      end

      it "creates a new user" do
        expect(User.exists?(email: "user@example.com")).to eq(true)
      end

      it "responds with the newly created user and a success message" do
        expect(response.parsed_body.key?("user")).to eq(true)
        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to eq("Signed up successfully.")
      end

      it "responds with a status code of 200" do
        expect(response).to be_successful
      end
    end

    context "When user is not registered successfully" do
      before do
        create_user(@wrong_user)
      end

      it "does not create a user" do
        expect(User.exists?(email: "user@example.com")).to eq(false)
      end

      it "responds with an accurate error message" do
        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to include("Email is invalid")

        allow_any_instance_of(User).to receive(:persisted?).and_return(false)
        create_user(@correct_user)

        expect(response.parsed_body.key?("message")).to eq(true)
        expect(response.parsed_body["message"]).to eq("Something went wrong.")
      end

      it "responds with a status code of 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
