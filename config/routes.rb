# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :account, only: %i[edit update], controller: 'accounts'
  resources :orders, only: [:create]

  # Defines the root path route ("/")
  root 'home#index'
end
