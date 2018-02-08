# frozen_string_literal: true

class SearchesController < ApplicationController

  def new

  end

  def show
    params[:sort_by] ||= :default_sort
    @events = Search::Events.call(current_user, Event.visible, search_params)
  end

  private

  def search_params
    params.permit(:page, :per_page, :sort_by, :default_sort,
      :by_text, :by_dates, :by_city, by_leisures: []
    )
  end
  helper_method :search_params
end
