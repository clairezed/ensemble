# frozen_string_literal: true

module EventHelper

  # visibilities -------------------------------------

  def event_visibility(visibility)
    I18n.t(visibility, scope: [:event, :visibilities, :title])
  end

  def event_visibility_style(visibility)
    I18n.t(visibility, scope: [:event, :visibilities, :style])
  end

  def event_visibility_options(visibilities = Event.visibilities.keys)
    visibilities.map do |visibility|
      [event_visibility(visibility), visibility.to_s]
    end
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

  # Adresse ---------------------------------------

  def event_full_address(event)
    [event.address, event.city.long_name].compact.reject(&:blank?).join(", ")
  end

  # Leisure ----------------------------------------
  def event_leisure_title(event)
    # event.leisure.present? ? event.leisure.title : event.leisure_category.title
    event.leisure_category.title
  end

  # ouverture -------------------------------------
  def event_openess_icon(key)
    key == 'opened' ? icon_country : icon_mail
  end

  # dates ----------------------------------------

  def event_date(event)
    if event.end_at.nil?
      l(event.start_at, format: :event)
    else
      "Du #{l(event.start_at, format: :event)} au #{l(event.end_at, format: :event)}"
    end
  end

  def event_short_date(event)
    if event.end_at.nil?
      l(event.start_at, format: '%A %d %B').downcase
    else
      "du #{l(event.start_at, format: '%A %d %B').downcase} au #{l(event.end_at, format: '%A %d %B').downcase}"
    end
  end

  # commentaires 

  def event_comments_count(event)
    comments = event.comments
    comments.any? ? comments.count : '-'
  end

  def event_pending_comments_count(event)
    pending = event.comments.pending
    return unless pending.any?
    content_tag :span, "#{pending.count} nv", class: "badge badge-warning"
  end

  # témoignages 

  def event_testimonies_count(event)
    testimonies = event.testimonies
    testimonies.any? ? testimonies.count : '-'
  end

  def event_pending_testimonies_count(event)
    pending = event.testimonies.pending
    return unless pending.any?
    content_tag :span, "#{pending.count} nv", class: "badge badge-warning"
  end


end