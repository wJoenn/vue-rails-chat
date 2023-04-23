require "rails_helper"

RSpec.describe User, type: :model do
  describe "#create" do
    it "creates a new user" do
      user = User.create(email: "a@a.a", password: "aaaaaa")

      expect(user.persisted?).to eq(true)
    end

    it "requires a valid email" do
      user_one = User.create(email: "", password: "aaaaaa")
      user_two = User.create(email: "a@a", password: "aaaaaa")
      user_three = User.create(password: "aaaaaa")

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(false)
      expect(user_three.persisted?).to eq(false)
    end

    it "requires a valid password" do
      user_one = User.create(email: "a@a.a")
      user_two = User.create(email: "a@a.a", password: "aaaaa")

      expect(user_one.persisted?).to eq(false)
      expect(user_two.persisted?).to eq(false)
    end

    it "requires an email to be unique" do
      User.create(email: "a@a.a", password: "aaaaaa")
      user = User.create(email: "a@a.a", password: "aaaaaa")

      expect(user.persisted?).to eq(false)
    end

    it "saves the password securely" do
      user = User.create(email: "a@a.a", password: "aaaaaa")

      expect(user.persisted?).to eq(true)
      expect(user.encrypted_password.nil?).to eq(false)
    end
  end
end
