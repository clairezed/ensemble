# frozen_string_literal: true

module EventHelper


  # visibilities -------------------------------------

  def event_visibility(visibility)
    I18n.t(visibility, scope: [:event, :visibilities])
  end

  # Participants ------------------------------------

  def event_participants_count(event)
    current_participants_count  = event.participants.count
    max_participants_count      = event.participants_max
    [current_participants_count, max_participants_count].join("/")
  end

  def event_full_address(event)
    [event.address, event.city.long_name].compact.join(", ")
  end


end