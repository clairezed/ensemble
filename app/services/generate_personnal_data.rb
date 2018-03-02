class GeneratePersonnalData
  require 'json'

  attr_accessor :user

  def self.call(user)
    self.new(user).call
  end

  def initialize(user)
    self.user = user
  end

  def call
    generate_user_json
  end

  private

  def generate_user_json
    @renderer = ::JSONAPI::Serializable::Renderer.new

    complete_hash = {
      user: user_data[:data][:attributes],
      organized_events: organized_events_data,
      event_participations: event_participations_data,
      comments: comments_data,
      testimonies: testimonies_data,
    }

    JSON.pretty_generate(complete_hash)
  end

  # ==================================================================

  def renderer
    @renderer ||= ::JSONAPI::Serializable::Renderer.new
  end


  def user_data
    renderer.render(user, 
      class: { User: SerializableUser, Leisure: SerializableLeisure, Language: SerializableLanguage},
      include: [:leisures, :languages]
    )
  end

  def organized_events_data
    renderer.render(user.organized_events, 
      class: { Event: SerializableEvent},
      include: [:leisure]
    )
  end

  def event_participations_data
    renderer.render(user.event_participations, 
      class: { EventParticipation: SerializableEventParticipation, Event: SerializableEvent},
      include: [:event]
    )
  end

  def comments_data
    renderer.render(user.comments, 
      class: { Comment: SerializableComment}
    )
  end

  def testimonies_data
    renderer.render(user.testimonies, 
      class: { Testimony: SerializableTestimony}
    )
  end

end