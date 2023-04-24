require "rails_helper"

RSpec.describe User, type: :model do
  let!(:email) { "user@example.com" }
  let!(:password) { "password" }
  let!(:username) { "Joenn" }

  describe "#create" do
    it "creates a new user" do
      user = User.create(email:, password:, username:)

      expect(user.persisted?).to eq(true)
    end

    it "requires a valid email" do
      user_one = User.create(password:, username:)
      user_two = User.create(email: "", password:, username:)
      user_three = User.create(email: "user@example", password:, username:)

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(false)
      expect(user_three.persisted?).to eq(false)
    end

    it "requires the email to be unique" do
      User.create(email:, password:, username:)
      user = User.create(email:, password:, username: "wJoenn")

      expect(user.persisted?).to eq(false)
    end

    it "requires a valid password" do
      user_one = User.create(email:, username:)
      user_two = User.create(email:, password: "short", username:)

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(false)
    end

    it "saves the password securely" do
      user = User.create(email:, password:, username:)

      expect(user.persisted?).to eq(true)
      expect(user.encrypted_password.nil?).to eq(false)
    end

    it "requires a valid username" do
      user_one = User.create(email:, password:)
      user_two = User.create(email:, password:, username:)

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(true)
    end

    it "requires the username to be unique" do
      User.create(email:, password:, username:)
      user = User.create(email: "joenn@example.com", password:, username:)

      expect(user.persisted?).to eq(false)
    end
  end
end
