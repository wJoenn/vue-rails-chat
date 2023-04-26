require "rails_helper"

def create_message(chatroom_id)
  post "/chatrooms/#{chatroom_id}/messages",
    params: { message: { content: "Hello World" } }.to_json,
    headers: { "Content-Type": "application/json" }
end

RSpec.describe "Messages", type: :request do
  let!(:user) { User.create(email: "user@example.com", password: "password", username: "Joenn") }
  let!(:chatroom) { Chatroom.create(name: "general") }

  describe "GET /index" do
    it "requires user authentification" do
      get "/chatrooms/#{chatroom.id}/messages"
      expect(response).to have_http_status(:found)
    end

    context "When user is logged in" do
      before do
        Message.create(content: "Hello World", chatroom:, user:)
        Message.create(content: "Bye World", chatroom:, user:)
        sign_in(user.email, user.password)
        get "/chatrooms/#{chatroom.id}/messages"
      end

      it "returns a list of Message from the current Chatroom" do
        list = response.parsed_body
        expect(list.length).to eq(2)

        expect(list.pluck("chatroom_id")).to all be(chatroom.id)
      end

      it "returns a http status 200" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /create" do
    it "requires user authentification" do
      create_message(chatroom.id)
      expect(response).to have_http_status(:found)
    end

    context "When user is logged in" do
      before do
        sign_in(user.email, user.password)
      end

      context "When saved" do
        before do
          create_message(chatroom.id)
        end

        # it "returns a Message if saved" do
        #   expect(response.parsed_body.key?("id")).to be_truthy
        # end

        it "returns a http status 200" do
          expect(response).to have_http_status(:success)
        end
      end

      context "When not saved" do
        before do
          create_message(10)
        end

        it "returns an error if not saved" do
          expect(response.parsed_body.first).to eq("Chatroom must exist")
        end

        it "returns a http status 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
