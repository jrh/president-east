# frozen_string_literal: true
module Api
  class UsersController < ApiController

    def show
      @user = User.find(params[:id])
      authorize @user
      render status: :ok, json: @user
    end

    def update
      @user = User.find(params[:id])
      authorize @user
      if @user.update(user_params)
        render status: :ok, json: @user
      else
        render status: :unprocessable_entity, json: @user.errors.full_messages
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :company)
    end
  end
end
