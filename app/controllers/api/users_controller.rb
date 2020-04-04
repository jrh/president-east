# frozen_string_literal: true
module Api
  class UsersController < ApiController

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        render status: :ok, json: @user
      else
        render status: :unprocessable_entity, :json: @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :company)
    end
  end
end
