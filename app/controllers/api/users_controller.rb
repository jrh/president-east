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
        render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
      end
    end

    def change_password
      @user = User.find(params[:id])
      authorize @user
      if @user && @user.authenticate(params[:current_password])
        if @user.update(user_params)
          render :ok, json: @user
        else
          render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
        end
      else
        render status: :unprocessable_entity, json: { errors: ['Current password is incorrect'] }
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :company, :password, :password_confirmation)
    end
  end
end
