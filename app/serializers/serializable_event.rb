class SerializableEvent < JSONAPI::Serializable::Resource
  include UserHelper
  include EventHelper
  type 'events'

  attributes :id, :title, :participants_max, :description, :start_at, :end_at, :created_at, :updated_at

  attribute :city do
    @object.city.try(:name)
  end

  attribute :creator do
    user_nickname(@object.user)
  end

  attribute :leisure do
    @object.leisure.title
  end

  attribute :address do 
    event_full_address(@object)
  end

  attribute :private_or_public do 
    event_visibility(@object.visibility)
  end

  attribute :state do 
    event_state_title(@object.state)
  end

  attribute :affiliation do 
    event_affiliation(@object.affiliation)
  end

end
