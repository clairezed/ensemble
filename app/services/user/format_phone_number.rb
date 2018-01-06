class User::FormatPhoneNumber

  def self.call(phone_number)
    self.new(phone_number).call
  end

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def call
    number = GlobalPhone.parse(@phone_number, :fr)
    return number.international_string unless number.blank?
  end

  private


  end