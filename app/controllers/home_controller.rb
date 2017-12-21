# frozen_string_literal: true

class HomeController < ApplicationController
  layout 'unregistered', only: [:index]

  skip_before_action :authenticate_user!
  skip_before_action :reject_blocked_ip!


  def index
    get_seo_for_static_page('home')
    @user = User.new_with_session({}, session)
  end

end
