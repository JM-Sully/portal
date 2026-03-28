# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :account, only: %i[edit update], controller: 'accounts'

  resources :products, only: [] do
    resource :booking, only: %i[new create], controller: 'bookings'
  end

  resources :orders, only: %i[show edit update]

  # Defines the root path route ("/")
  root 'home#index'
end
