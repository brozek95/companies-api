Rails.application.routes.draw do
  resources :companies, only: :create
  resources :companies_import, only: :create
end
