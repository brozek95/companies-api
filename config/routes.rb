Rails.application.routes.draw do
  resources :companies, only: :create
end
