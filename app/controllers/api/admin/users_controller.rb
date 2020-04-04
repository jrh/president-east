module Api
  module Admin
    class UsersController < ApiController
      before_action :authenticate_user

      def index
        @users = User.all
        render status: :ok, json: @users
      end

      def create
        @user = User.new(user_params)
        if @user.save

          render json: { current_user: @user }
        else
          render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
        end
      end

      def update
        @user = User.find(params[:id])
        if @user.update(user_params)
          render status: :ok, json: @user
        else
          render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company, :role)
      end
    end
  end
end
