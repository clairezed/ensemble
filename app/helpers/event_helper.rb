# frozen_string_literal: true

module EventHelper


  # visibilities -------------------------------------

  def event_visibility(visibility)
    I18n.t(visibility, scope: [:event, :visibilities])
  end

  # Affiliation

  def event_affiliation(affiliation)
    I18n.t(affiliation, scope: [:event, :affiliations])
  end

  # Etat -----------------------------------------------

  def event_state_title(state)
    I18n.t(state, scope: %i(event states title))
  end

  def event_state_style(state)
    I18n.t(state, scope: %i(event states style))
  end

  def event_state_options(states = Event.states.keys)
    states.map do |state|
      [event_state_title(state), state.to_s]
    end
  end

  # Participants ------------------------------------

  def event_participants_count(event)
    current_participants_count  = event.participants.count
    max_participants_count      = event.participants_max
    [current_participants_count, max_participants_count].join("/")
  end

  # Adresse

  def event_full_address(event)
    [event.address, event.city.long_name].compact.reject(&:blank?).join(", ")
  end

  # Leisure
  def event_leisure_title(event)
    event.leisure.present? ? event.leisure.title : event.leisure_category.title
  end

  def event_openess_icon(key)
    key == 'opened' ? 'fa-globe' : 'fa-envelope'
  end


end