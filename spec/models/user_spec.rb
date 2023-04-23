require "rails_helper"

RSpec.describe User, type: :model do
  describe "#create" do
    it "creates a new user" do
      user = User.create(email: "user@example.com", password: "password")

      expect(user.persisted?).to eq(true)
    end

    it "requires a valid email" do
      user_one = User.create(password: "password")
      user_two = User.create(email: "", password: "password")
      user_three = User.create(email: "user@example", password: "password")

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(false)
      expect(user_three.persisted?).to eq(false)
    end

    it "requires a valid password" do
      user_one = User.create(email: "user@example.com")
      user_two = User.create(email: "user@example.com", password: "short")

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(false)
    end

    it "requires an email to be unique" do
      User.create(email: "user@example.com", password: "password")
      user = User.create(email: "user@example.com", password: "password")

      expect(user.persisted?).to eq(false)
    end

    it "saves the password securely" do
      user = User.create(email: "user@example.com", password: "password")

      expect(user.persisted?).to eq(true)
      expect(user.encrypted_password.nil?).to eq(false)
    end
  end
end
