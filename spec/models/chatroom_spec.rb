require "rails_helper"

RSpec.describe Chatroom, type: :model do
  let!(:chatroom) { Chatroom.create(name: "general") }
  describe "validation" do
    it "creates a new Chatroom with proper params" do
      expect(chatroom.persisted?).to be_truthy
    end

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
