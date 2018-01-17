class CitiesController < ApplicationController
  # aussi utile cote admin
  skip_before_action :reject_blocked_ip!
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :check_registration_uncomplete, only: [:index]

  def index
    params[:by_val] ||= current_user.city.department_code
    @cities = City.by_name_or_zipcode(params[:by_val])
    respond_to do |format|
      format.html do
        @cities
      end
      format.json do
        # format spécifique select2
        render json: @cities.limit(15).map { |city| { "id": city.id, "text": city.long_name } }
      end
    end
  end
end