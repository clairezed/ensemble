# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin

  devise_for :user, path: "mon-compte", controllers: {
        sessions: 'user/sessions',
        registrations: 'user/registrations',
        passwords: 'user/passwords',
        confirmations: 'user/confirmations'
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
    resources :leisure_categories
    resources :leisures
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
    resources :events
    resources :past_events, only: :index
  end

  # Front ======================================

  resources :profiles, only: [:show]
  resources :cities, only: [:index]
  resources :events, only: [:index, :show]

  resources :basic_pages, only: [:show]

  put '/accept_cookies', to: 'home#accept_cookies'
  get '/:filename', to: 'statics#show'

  devise_scope :user do
    authenticated :user do
      root 'events#index', as: :authenticated_root
    end
  end

  root to: 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
