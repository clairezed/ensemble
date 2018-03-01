# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  before_action :initialize_settings

  def index
    respond_to do |format|
      format.html
      format.js do
        data = Statistics::ComputeEventStats.call({begin_at: params[:begin_at], end_at: params[:end_at]})
        render json: { success: true, data: data }, content_type: 'application/json'
      end
    end
  end

  def initialize_settings
    params[:begin_at]   ||= 30.days.ago.to_date-1.day
    params[:end_at]     ||= Date.current-1.day
  end

end
