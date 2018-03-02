class SerializableLanguage < JSONAPI::Serializable::Resource
  type 'languages'

  attributes :id, :title
 
end
