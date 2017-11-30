# frozen_string_literal: true

class HomeController < ApplicationController
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
