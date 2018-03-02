class SerializableComment < JSONAPI::Serializable::Resource
  type 'comments'

  attributes :id, :event_id, :body, :created_at, :updated_at

  attribute :event_title do
    @object.event.title
  end

  # belongs_to :event

 
end
