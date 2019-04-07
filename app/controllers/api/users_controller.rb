module Api
  class UsersController < ApiController

    def create
      user = User.new(user_params)
      if user.save
        render status: :created, json: { message: 'User created successfully' }
      else
        render status: :bad_request, json: { errors: user.errors.full_messages }
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end
