module Api
  class AuthenticationController < ApiController

    def create
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        auth_token = JsonWebToken.encode({ user_id: user.id })
        render status: :ok, json: { auth_token: auth_token, current_user: user }
        puts 'TOKEN CREATED'
      else
        puts 'UNAUTHORIZED'
        render status: :unauthorized, json: { error: 'Login Unsuccessful' }
      end
    end
  end
end
