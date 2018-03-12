# frozen_string_literal: true

class StaticsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_registration_uncomplete
  
  def show
    render action: params[:filename], layout: params[:filename] != 'landing'
  rescue ActionView::MissingTemplate
    redirect_to '/404'
  end
end
