# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin

  devise_for :users, path: "mon-compte", controllers: {
        sessions: 'user/sessions',
        registrations: 'user/registrations'
      }


  # Concerns ======================================

  concern :positionable do
    patch :position, on: :member
  end

  # Admin ======================================

  namespace :admin do
    resources :admins
    resources :basic_pages, concerns: :positionable
    resources :seos, only: %i[index edit update]
    resources :users
    root to: 'dashboard#index'
  end

  # User ======================================
  scope controller: 'user/registrations' do
      get  :new_second_step, path: 'finaliser-inscription'
      patch :create_second_step
      get :edit_profile
      patch :update_profile
    end

  namespace :user do
  end

  resources :profiles, only: [:show]
  # Front ======================================

  resources :basic_pages, only: [:show]
  put '/accept_cookies', to: 'home#accept_cookies'
  get '/:filename', to: 'statics#show'

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
