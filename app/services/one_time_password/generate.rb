module OneTimePassword

  class Generate < Base

    def call(counter)
      return hotp.at(counter)
    end

  end

end