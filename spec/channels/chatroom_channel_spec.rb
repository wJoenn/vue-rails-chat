require "rails_helper"

RSpec.describe ChatroomChannel, type: :channel do
  let!(:user) { User.create(email: "user@example.com", password: "password", username: "Joenn") }
  let!(:chatroom) { Chatroom.create(name: "general") }
  let!(:message) { Message.create(content: "Hello World", username: user.username, user:, chatroom:) }

  before(:each) do
    subscribe(id: chatroom.id)
  end

  it "subscribes to the chatroom channel" do
    expect(subscription).to be_confirmed
  end

  it "unsubscribes from the chatroom channel" do
    expect(subscription).to be_confirmed

    subscription.unsubscribe_from_channel
    expect(subscription.streams).to be_empty
  end
end
