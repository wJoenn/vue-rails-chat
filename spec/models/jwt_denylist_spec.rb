require "rails_helper"

RSpec.describe JwtDenylist, type: :model do
  let(:jti) { "token" }
  let(:exp) { 1.month.from_now }

  describe "#create" do
    it "adds a token to the denylist" do
      jwt = JwtDenylist.create!(jti:, exp:)

      expect(jwt.persisted?).to be_truthy
    end
  end
end
