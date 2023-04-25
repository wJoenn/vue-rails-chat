require "rails_helper"

RSpec.describe Chatroom, type: :model do
  let!(:chatroom) { Chatroom.create(name: "general") }

  describe "validation" do
    it "creates a new Chatroom with proper params" do
      expect(chatroom.persisted?).to be_truthy
    end

    context "name" do
      it "requires a valid name" do
        chatroom = Chatroom.create

        expect(chatroom.persisted?).to be_falsy
      end

      it "requires the name to be unique" do
        chatroom_dup = Chatroom.create(name: "general")

        expect(chatroom_dup.persisted?).to be_falsy
      end
    end
  end

  describe "association" do
    let(:user) { User.create(email: "user@example.com", password: "password", username: "Joenn") }

    context "messages" do
      it "can have one or many messages" do
        Message.create(user:, chatroom:, content: "Hello World")
        expect(chatroom.messages.any?).to be_truthy

        Message.create(user:, chatroom:, content: "Bye World")
        expect(chatroom.messages.length).to eq(2)
      end
    end

    context "users" do
      it "can have one or many users" do
        Message.create(user:, chatroom:, content: "Hello World")
        expect(chatroom.users.any?).to be_truthy

        user = User.create(email: "new_user@example.com", password: "password", username: "Cornebusaille")
        Message.create(user:, chatroom:, content: "Bye World")
        expect(chatroom.users.length).to eq(2)
      end
    end
  end
end
