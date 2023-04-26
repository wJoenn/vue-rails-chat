Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  resources :chatrooms, only: %i[index] do
    resources :messages, only: %i[index create]
  end

  get "/member-data", to: "members#show"
end
