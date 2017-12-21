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
    resources :users do 
      member do
        get :edit_profile
        patch :update_profile
        patch :accept
        patch :reject
      end
    end
    resources :events do
      member do
        patch :cancel
        patch :activate
      end
    end
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
    resources :sms_confirmations, only: [:new, :create, :update] do 
      get :new_verify, on: :collection
      patch :verify, on: :collection
    end
    resources :events do
      resources :event_invitations, as: :invitations, controller: "events/event_invitations" do 
        patch :batch_valildate, on: :collection
      end
      resources :searched_invited_users, controller: "events/searched_invited_users", only: [:index]
    end
    resources :past_events, only: :index
    resources :event_invitations, as: :invitations, only: [:index, :edit] do
      member do
        patch :accept
        patch :reject
      end
    end
  end

  # Front ======================================

  resources :profiles, only: [:show]
  resources :cities, only: [:index]
  resources :events, only: [:index, :show]

  scope module: :events do
   resources :events, only: [] do
    resources :event_participations
   end
  end

  resource :search, only: [:new, :show]

  resources :basic_pages, only: [:show]
  resources :sms_notifications, only: [:index]

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
