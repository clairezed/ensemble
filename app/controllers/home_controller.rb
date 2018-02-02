# frozen_string_literal: true

class HomeController < ApplicationController
  # layout 'unregistered', only: [:index]

  skip_before_action :authenticate_user!
  skip_before_action :reject_blocked_ip!

end
