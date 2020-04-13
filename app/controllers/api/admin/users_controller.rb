# frozen_string_literal: true
module Api
  module Admin
    class UsersController < ApiController
      before_action :authenticate_user

      def index
        authorize([:admin, User])
        @users = User.all
        render status: :ok, json: @users
      end

      def update
        @user = User.find(params[:id])
        authorize([:admin, @user])
        if @user.update(user_params)
          render status: :ok, json: @user
        else
          render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
        end
      end

      private

      def user_params
        params.require(:user).permit(:role)
      end
    end
  end
end
