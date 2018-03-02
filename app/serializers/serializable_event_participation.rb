class SerializableEventParticipation < JSONAPI::Serializable::Resource
  type 'event_participations'

  attributes  :id, :event_id, :created_at, :updated_at

  belongs_to :event

 
end
