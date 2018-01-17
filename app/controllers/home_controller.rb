# frozen_string_literal: true

class HomeController < ApplicationController
  # layout 'unregistered', only: [:index]

  skip_before_action :authenticate_user!
  skip_before_action :reject_blocked_ip!


  # def index
  #   get_seo_for_static_page('home')
  #   @last_events = Event.active.order(created_at: :desc).limit(3)
  #   @mirador_events = Event.active.mirador.order(created_at: :desc).limit(3)
  #   @user = User.new_with_session({}, session)
  # end

end
