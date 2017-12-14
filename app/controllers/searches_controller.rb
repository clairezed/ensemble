# frozen_string_literal: true

class SearchesController < ApplicationController

  def new

  end

  def show
    @events = Search::Events.call(current_user, Event, search_params)
  end

  private

  def search_params
    params.permit(:by_text, :by_dates, :by_city, :by_leisure_category)
  end
  helper_method :search_params
end
