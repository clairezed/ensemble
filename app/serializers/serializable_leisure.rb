class SerializableLeisure < JSONAPI::Serializable::Resource
  type 'leisures'

  attributes :id, :title

  attribute :category_title do
    @object.leisure_category.title
  end

 
end
