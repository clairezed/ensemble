# frozen_string_literal: true

class HomeController < ApplicationController
  layout 'unregistered', only: [:index]

  # TODO check why it suddenly doesnt work anymore?
  protect_from_forgery with: :null_session, only: [:accept_cookies]

  skip_before_action :authenticate_user!
  skip_before_action :reject_blocked_ip!


  def index
    get_seo_for_static_page('home')
    @user = User.new_with_session({}, session)
  end

  def accept_cookies
    cookies.permanent['cookies_accepted'] = true
    render json: {
      cookies_accepted: true
    }
  end
end
