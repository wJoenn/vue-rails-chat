module Helpers
  module Authentication
    def sign_in(email, password)
      post "/users/sign_in",
        params: { user: { email:, password: } }.to_json,
        headers: { "Content-Type": "application/json" },
        env: { "devise.mapping": Devise.mappings[:user] }
    end
  end
end
