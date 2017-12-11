module OneTimePassword

  class Verify < Base

    def call(code, counter)
      return hotp.verify(code.to_s, counter.to_i)
    end

  end

end