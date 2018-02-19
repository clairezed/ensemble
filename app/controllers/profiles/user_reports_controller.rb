# frozen_string_literal: true

class Profiles::UserReportsController < Profiles::BaseController
 
  before_action :find_user_report, only: %i[destroy]

  def new
    @user_report = current_user.created_user_reports.new(reported_user_id: @profile.id)
    respond_to do |format|
      format.html
      format.js do
        html = render_to_string(action: :new, layout: false)
        render json: { success: true, html: html }, content_type: 'application/json'
      end
    end
  end

  def create
    @user_report = current_user.created_user_reports.new(user_report_params)
    respond_to do |format|
      format.js do
        if @user_report.save
          render json: { success: true  }, content_type: 'application/json'
        else
          html = render_to_string(action: :new, layout: false)
          render json: { success: false, html: html }, content_type: 'application/json'
        end
      end
    end
  end

  def destroy
    if @user_report.update(blocked: false)
      flash[:notice] = "L'utilisateur a été débloqué"
    else
      flash[:error] = "Il y a eu un problème, veuillez réessayer plus tard"
    end
    redirect_back fallback_location: profile_path(@profile)
  end

  private

  def find_user_report
    @user_report = current_user.created_user_reports.find params[:id]
  end

  # strong parameters
  def user_report_params
    params.require(:user_report).permit(
      :reported_user_id, :comment
      )
  end

end

