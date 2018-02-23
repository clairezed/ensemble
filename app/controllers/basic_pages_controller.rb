# frozen_string_literal: true

class BasicPagesController < ApplicationController
  include SlugsAndRedirections
  skip_before_action :authenticate_user!
  skip_before_action :reject_blocked_ip!

  def show
    @basic_page = get_object_from_param_or_redirect(BasicPage.enabled)
  end
end
