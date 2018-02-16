class Profiles::BaseController < ApplicationController
  before_action :load_profile

  private

  def load_profile
    @profile = User.find(params[:profile_id])
  end

end