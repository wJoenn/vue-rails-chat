require "rails_helper"

RSpec.describe User, type: :model do
  let!(:email) { "user@example.com" }
  let!(:password) { "password" }
  let!(:username) { "Joenn" }
  let!(:user) { User.create(email:, password:, username:) }

  describe "validation" do
    it "creates a new user with the proper params" do
      expect(user.persisted?).to be_truthy
    end

    context "email" do
      it "requires a valid email" do
        user = User.create(password:, username:)
        expect(user.persisted?).to be_falsy

        user = User.create(email: "", password:, username:)
        expect(user.persisted?).to be_falsy

        user = User.create(email: "user@example", password:, username:)
        expect(user.persisted?).to be_falsy
      end

      it "requires the email to be unique" do
        user_dup = User.create(email:, password:, username: "wJoenn")

        expect(user_dup.persisted?).to be_falsy
      end
    end

    context "password" do
      it "requires a valid password" do
        user = User.create(email:, username:)
        expect(user.persisted?).to be_falsy

        user = User.create(email:, password: "short", username:)
        expect(user.persisted?).to be_falsy
      end

      it "saves the password securely" do
        expect(user.encrypted_password.nil?).to be_falsy
      end
    end

    context "username" do
      it "requires a valid username" do
        user = User.create(email:, password:)

        expect(user.persisted?).to be_falsy
      end

      it "requires the username to be unique" do
        user_dup = User.create(email: "joenn@example.com", password:, username:)

        expect(user_dup.persisted?).to be_falsy
      end
    end
  end

  describe "association" do
    context "messages" do
      it "can have one or many messages" do
        chatroom = Chatroom.create(name: "general")
        Message.create(user:, chatroom:, content: "Hello World")
        expect(user.messages.any?).to be_truthy

        Message.create(user:, chatroom:, content: "Bye World")
        expect(user.messages.length).to eq(2)
      end
    end
  end
end
