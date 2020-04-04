module Api
  class UserTokenController < Knock::AuthTokenController

    def create
      response.set_cookie(
        :jwt,
        {
          value: auth_token.token,
          # expires: 2.minutes.from_now, # shorter time for testing
          expires: 30.minutes.from_now,
          path: '/',
          # secure: Rails.env.production?,
          httponly: Rails.env.production?
        }
      )

      render status: :created, json: auth_token.payload
    end
  end
end
