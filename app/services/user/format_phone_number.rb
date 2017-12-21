class User::FormatPhoneNumber

  def self.call(phone_number)
    self.new(phone_number).call
  end

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def call
    return if @phone_number.blank?
    GlobalPhone.parse(@phone_number, :fr).international_string
  end

  private


  end