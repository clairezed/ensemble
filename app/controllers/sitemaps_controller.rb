class SitemapsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :reject_blocked_ip!
  respond_to :html, :xml

  def show
    get_seo_for_static_page("sitemap")
    @site_map = Sitemap.get_all_pages

    respond_with(@site_map) do |format|
      format.html {}
      format.xml { render layout: false }
    end
  end
end
