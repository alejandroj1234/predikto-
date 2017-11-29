Rails.application.routes.draw do
  devise_for :users, :controllers => {
      confirmations: "users/confirmations",
      omniauth: "users/omniauth",
      passwords: "users/passwords",
      registrations: "users/registrations",
      sessions: "users/sessions",
      unlocks: "users/unlocks"
  }

  root to: "homepage#index"
  get "dashboard",       to: "dashboard#index"
end
