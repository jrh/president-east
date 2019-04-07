module Api
  class UsersController < ApiController

    def create
      user = User.new(user_params)
      if user.save
        auth_token = JsonWebToken.encode({ user_id: user.id })
        render status: :created, json: { auth_token: auth_token, current_user: user }
      else
        render status: :bad_request, json: { errors: user.errors.full_messages }
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company)
    end
  end
end
