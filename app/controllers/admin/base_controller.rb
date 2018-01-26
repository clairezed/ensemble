# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  skip_before_action :reject_blocked_ip!
  skip_before_action :authenticate_user!
  skip_before_action :check_registration_uncomplete
  
  before_action :authenticate_admin!
  layout 'administration'

  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = 'Element non trouvé'
    redirect_to admin_root_path unless request.xhr?
  end
end
