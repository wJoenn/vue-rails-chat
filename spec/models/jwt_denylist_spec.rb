require "rails_helper"

RSpec.describe JwtDenylist, type: :model do
  let(:jti) { "token" }
  let(:exp) { 1.month.from_now }

  describe "validation" do
    it "creates a new JwtDenylist with proper params" do
      jwt = JwtDenylist.create(jti:, exp:)

      expect(jwt.persisted?).to be_truthy
    end

    context "jti" do
      it "requires a valid json token id" do
        jwt = JwtDenylist.create(exp:)

        expect(jwt.persisted?).to be_falsy
      end
    end

    context "exp" do
      it "requires a valid expiration date" do
        jwt = JwtDenylist.create(jti:)
        expect(jwt.persisted?).to be_falsy

        jwt = JwtDenylist.create(jti:, exp: "Not a date")
        expect(jwt.persisted?).to be_falsy
      end
    end
  end
end
