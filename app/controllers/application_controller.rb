# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit

  protect_from_forgery with: :exception
  before_action :http_authentication

  before_action :reject_blocked_ip!
  before_action :authenticate_user!
  before_action :check_registration_uncomplete

  before_action :set_default_seos!#, :get_basic_pages
  after_action :flash_to_headers, if: -> { request.xhr? && flash.present? }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def get_seo_for_static_page(param)
    seo = Seo.where(param: param).first
    if seo
      @seo_title       = seo.title if seo.title.present?
      @seo_description = seo.description if seo.description.present?
      @seo_keywords    = seo.keywords if seo.keywords.present?
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_path unless request.xhr?
  end

  private

  def set_default_seos!
    @seo_title       ||= 'Ensemble'
    @seo_description ||= 'Ensemble, partageons nos mondes'
    @seo_keywords    ||= 'ensemble, intercultturalite, rencontres'
  end

  # Pour les requêtes ajax
  def flash_to_headers
    %i[error alert warning notice].each do |type|
      next if flash[type].blank?
      content = { message: flash[type], type: ApplicationHelper::FLASH_BS_TYPES[type] }
      response.headers['X-Message'] = content.to_json
      flash.discard
      break
    end
  end

  def get_basic_pages
    @basic_pages = BasicPage.where(enabled: true).order(position: :asc)
  end

  def http_authentication
    if Rails.env.staging? || Rails.env.production?
      authenticate_or_request_with_http_basic do |username, password|
        username == 'mirador' && password == 'ensemble2018'
      end
    end
  end

  def reject_blocked_ip!
    current_ip = request.remote_ip

    if User.blocked_ips.include?(current_ip)
      flash[:error] = "Cette adresse IP n'est pas autorisée à accéder à Ensemble"
      redirect_to root_path
    end
  end

  def check_registration_uncomplete
    if current_user.present? && !current_user.registration_complete?
      redirect_to new_second_step_path
    end
  end

  def user_not_authorized
    flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action"
    redirect_to(request.referrer || authenticated_root_path)
  end

end
