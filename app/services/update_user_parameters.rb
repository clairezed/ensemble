
class UpdateUserParameters

  attr_accessor :params, :user

  def self.call(user, params={})
    self.new(user, params).call
  end

  def initialize(user, params={})
    self.user = user
    self.params = params
  end

  # Méthode custom pour gérer un peu plus finement la mise à jour
  # et les messages d'erreur.
  def call
    if params[:password].present? || params[:email] != user.email
      result = user.update_with_password(params)
      if user.errors.include?(:current_password)
        user.errors.delete(:current_password)
        user.errors.add(:current_password, :email_required_for_security)
      end
      return result
    else
      user.update_without_password(params.except(:current_password))
    end
  end

  private



  end