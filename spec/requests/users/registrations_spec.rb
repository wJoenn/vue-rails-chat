require "rails_helper"

def create_user(params)
  post "/users",
    params: { user: params }.to_json,
    headers: { "Content-Type": "application/json" },
    env: { "devise.mapping": Devise.mappings[:user] }
end

RSpec.describe "Users::Registrations", type: :request do
  describe "POST /create" do
    let!(:correct_user_params) { { email: "user@example.com", password: "password", username: "Joenn" } }
    let!(:wrong_user_params) { { email: "user@example", password: "password", username: "Joenn" } }

    shared_examples "a JSON object" do
      it "responds with a JSON object" do
        expect(response.body.class).to be(String)
        expect(response.parsed_body.class).to be(Hash)
      end
    end

    context "When user is registered successfuly" do
      before do
        create_user(correct_user_params)
      end

      it_behaves_like "a JSON object"

      it "creates a new user" do
        expect(User.exists?(email: "user@example.com")).to be_truthy
      end

      it "responds with the newly created user and a success message" do
        expect(response.parsed_body.key?("user")).to be_truthy
        expect(response.parsed_body["message"]).to eq("Signed up successfully.")
      end

      it "responds with a status code of 200" do
        expect(response).to be_successful
      end
    end

    context "When user is not registered successfully" do
      before do
        create_user(wrong_user_params)
      end

      it_behaves_like "a JSON object"

      it "does not create a user" do
        expect(User.exists?(email: "user@example.com")).to be_falsy
      end

      it "responds with an accurate error message" do
        expect(response.parsed_body["message"]).to include("Email is invalid")

        allow_any_instance_of(User).to receive(:persisted?).and_return(false)
        create_user(correct_user_params)

        expect(response.parsed_body["message"]).to eq("Something went wrong.")
      end

      it "responds with a status code of 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
