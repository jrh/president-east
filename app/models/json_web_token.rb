class JsonWebToken

  def self.encode(payload)
    payload.reverse_merge!(meta)
    if Rails.env.production?
      JWT.encode(payload, ENV['JWT_SECRET'])
    else
      JWT.encode(payload, Rails.application.credentials.jwt_secret)
    end
  end

  def self.decode(token)
    if Rails.env.production?
      JWT.decode(token, ENV['JWT_SECRET'])
    else
      JWT.decode(token, Rails.application.credentials.jwt_secret)
    end
  end

  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client'
    }
  end

  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end

end
