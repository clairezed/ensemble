class User::ConfirmPhoneNumber

  attr_accessor :user

  def self.call(user, params)
    self.new(user, params).call
  end

  def initialize(user, params)
    @user = user
    @user.sms_token = params[:sms_token]
  end

  def call
    if @user.sms_token.blank?
      @user.errors.add(:sms_token, :blank) 
      return false
    elsif OneTimePassword::Verify.call(@user.sms_token, @user.id)
      @user.touch(:sms_confirmed_at)
      @user.verify_identity! if (@user.confirmed? && @user.may_verify_identity?)
      true
    else
      @user.errors.add(:sms_token, :wrong)
      false
    end
  end

  private


  end