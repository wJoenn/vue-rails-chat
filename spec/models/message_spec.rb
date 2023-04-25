require "rails_helper"

RSpec.describe Message, type: :model do
  let!(:user) { User.create(email: "user@example.com", password: "password", username: "Joenn") }
  let!(:chatroom) { Chatroom.create(name: "general") }
  let!(:message) { Message.create(user:, chatroom:, content: "Hello World") }

  describe "validation" do
    it "creates a new message with proper params" do
      expect(message.persisted?).to be_truthy
    end

    context "content" do
      it "requires a valid content" do
        message = Message.create(user:, chatroom:)

        expect(message.persisted?).to be_falsy
      end
    end
  end

  describe "association" do
    context "user" do
      it "belongs to a user" do
        expect(message.user.class).to be(User)

        message = Message.create(chatroom:, content: "Hello World")
        expect(message.persisted?).to be_falsy
      end

      it "is destroyed if its user is destroyed" do
        user.destroy

        expect(Message.any?).to be_falsy
      end
    end

    context "chatroom" do
      it "belongs to a chatroom" do
        expect(message.chatroom.class).to be(Chatroom)

        message = Message.create(chatroom:, content: "Hello World")
        expect(message.persisted?).to be_falsy
      end

      it "is destroyed if its chatroom is destroyed" do
        chatroom.destroy

        expect(Message.any?).to be_falsy
      end
    end
  end
end
