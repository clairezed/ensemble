class DeviseCustomFailure < Devise::FailureApp
  # cf https://codedump.io/share/wtx6ICBn6BSX/1/devise-with-confirmable---redirect-user-to-a-custom-page-when-users-tries-to-sign-in-with-an-unconfirmed-email
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated

  def redirect_url
    if warden_message == :unconfirmed
      new_user_confirmation_path
      # new_user_confirmation_url(:subdomain => 'secure')
    else
      super
    end
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end
