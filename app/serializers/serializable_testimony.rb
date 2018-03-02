class SerializableTestimony < JSONAPI::Serializable::Resource
  type 'testimonies'

  attributes :id, :admin_comment, :public_comment, :created_at, :updated_at

  
  attribute :event_title do
    @object.event.title
  end


  # belongs_to :event
 
end
