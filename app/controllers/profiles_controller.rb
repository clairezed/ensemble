# frozen_string_literal: true

class ProfilesController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
end
