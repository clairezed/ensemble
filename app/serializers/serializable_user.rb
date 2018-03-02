class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'

  attributes :id, :email, :encrypted_password, :created_at, :updated_at, 
  :firstname, :lastname, :gender, :birthdate, :phone, :description,
  :visited_countries, :rank,
  :sms_notification, :email_notification, :registration_complete, :affiliation, 
  :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count,
  :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, 
  :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email,
  :sms_confirmation_token, :sms_confirmed_at, :sms_confirmation_sent_at,
  :verification_state, :cgu_accepted_at

  attribute :city do
    @object.city.try(:name)
  end

  attribute :leisures_title do 
    @object.leisures.map do |leisure| 
      "#{leisure.title} (#{leisure.leisure_category.title})"
    end.join(", ")
  end

  attribute :languages_title do 
    @object.languages.map do |language| 
      language.title
    end.join(", ")
  end

  has_many :leisures do 
    meta do
      { count: @object.leisures.count }
    end
  end

  has_many :languages

  has_many :organized_events
  has_many :event_participations

  has_many :comments
  has_many :testimonies

end
