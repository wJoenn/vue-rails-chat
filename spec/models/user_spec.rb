require "rails_helper"

RSpec.describe User, type: :model do
  let!(:email) { "user@example.com" }
  let!(:password) { "password" }
  let!(:username) { "Joenn" }
  let!(:user) { User.create(email:, password:, username:) }

  describe "#create" do
    it "creates a new user" do
      expect(user.persisted?).to be_truthy
    end

    it "requires a valid email" do
      user_one = User.create(password:, username:)
      user_two = User.create(email: "", password:, username:)
      user_three = User.create(email: "user@example", password:, username:)

      expect(user_one.persisted?).to be_falsy
      expect(user_two.persisted?).to be_falsy
      expect(user_three.persisted?).to be_falsy
    end

    it "requires the email to be unique" do
      user_one = User.create(email:, password:, username: "wJoenn")

      expect(user_one.persisted?).to be_falsy
    end

    it "requires a valid password" do
      user_one = User.create(email:, username:)
      user_two = User.create(email:, password: "short", username:)

      expect(user_one.persisted?).to be_falsy
      expect(user_two.persisted?).to be_falsy
    end

    it "saves the password securely" do
      expect(user.encrypted_password.nil?).to be_falsy
    end

    it "requires a valid username" do
      user_one = User.create(email:, password:)

      expect(user_one.persisted?).to be_falsy
    end

    it "requires the username to be unique" do
      user_one = User.create(email: "joenn@example.com", password:, username:)

      expect(user_one.persisted?).to be_falsy
    end
  end
end
