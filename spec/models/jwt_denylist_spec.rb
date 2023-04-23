require "rails_helper"

RSpec.describe JwtDenylist, type: :model do
  describe "#create" do
    it "adds a token to the denylist" do
      jti = "68s4rg35rhq5dr4h3qrdhqd9r5h4qw3d9r5hq"
      exp = Time.current + 1.month.to_i
      jwt = JwtDenylist.create!(jti:, exp:)

      expect(jwt.persisted?).to eq(true)
    end
  end
end
