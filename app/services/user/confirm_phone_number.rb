class User::ConfirmPhoneNumber

  attr_accessor :code, :user

  def self.call(user, code)
    self.new(user, code).call
  end

  def initialize(user, code)
    self.user = user
    self.code = code
  end

  def call
    if OneTimePassword::Verify.call(code, user.id)
      user.touch(:sms_confirmed_at)
      true
    else
      false
    end
  end

  end