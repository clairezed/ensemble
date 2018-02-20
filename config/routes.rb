  # frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin

  devise_for :users, path: "mon-compte", controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        passwords: 'users/passwords',
        confirmations: 'users/confirmations'
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
      resources :comments, controller: "events/comments", only: [:index] do 
        member do
          patch :accept
          patch :reject
        end
      end
    end
    resources :leisure_categories
    resources :leisures
    resources :user_reports, only: [:index]
    root to: 'dashboard#index'
  end

  # User ======================================
  scope controller: 'users/registrations' do
    get  :new_second_step, path: 'finaliser-inscription'
    patch :create_second_step
  end

  namespace :users do
    resources :avatars
    resources :sms_confirmations, only: [:new, :create, :update] do 
      get :new_verify, on: :collection
      patch :verify, on: :collection
    end
    resource :parameters, only: [:show, :edit, :update] do 
      get :edit_password
      patch :update_password
    end
    resources :events do
      resources :event_invitations, as: :invitations, controller: "events/event_invitations" do 
        patch :batch_valildate, on: :collection
      end
      resources :searched_invited_users, controller: "events/searched_invited_users", only: [:index]
      resources :event_pictures, as: :pictures, controller: "events/event_pictures"
      resources :event_attachments, as: :attachments, controller: "events/event_attachments"

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

  resources :profiles, only: [:show] do
    resources :user_reports, as: :reports, controller: "profiles/user_reports", only: [:new, :create, :destroy]
  end
  resources :cities, only: [:index]
  resources :events, only: [:index, :show], path: 'evenements'
  resources :mirador_events, only: [:index], path: 'evenements-mirador'

  scope module: :events do
    resources :events, only: [] do
      resources :event_participations, only: [:create, :destroy]
      resources :comments, only: [:create]
    end
  end

  resource :search, only: [:new, :show]

  resources :basic_pages, only: [:show]
  resources :sms_notifications, only: [:index]

  get '/:filename', to: 'statics#show'

  devise_scope :user do
    authenticated :user do
      root 'events#index', as: :authenticated_root
    end
  end

  root to: 'users/registrations#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
