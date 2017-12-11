module OneTimePassword
  # https://github.com/mdp/rotp

  class Base

    SECRET = Rails.application.secrets.secret_base_32

    def self.call(*params)
      self.new.call(*params)
    end

    def hotp
      @hotp ||= ROTP::HOTP.new(SECRET)
    end

  end

end