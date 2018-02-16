class Admin::UserReportsController < Admin::BaseController

  def index
    @user_reports = UserReport.includes(:user).includes(:reported_user)
      .apply_filters(params)
      .apply_sorts(params)
      .page(params[:page]).per(20)
  end

 
  private # =====================================================
 
end