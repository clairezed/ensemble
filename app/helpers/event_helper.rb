# frozen_string_literal: true

module EventHelper


  # visibilities -------------------------------------

  def event_visibility(visibility)
    I18n.t(visibility, scope: [:event, :visibilities])
  end

end