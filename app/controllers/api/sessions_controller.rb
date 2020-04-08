# frozen_string_literal: true
module Api
  class SessionsController < ApiController

    def create
      @user = User.find_by_email(login_params[:email])
      if @user && @user.authenticate(login_params[:password])
        session[:user_id] = @user.id
        render status: :ok, json: @user
      else
        render status: 403, json: { message: 'Invalid email or password' }
      end
    end

    def destroy
      session.delete(:user_id)
      @current_user = nil

      render status: :ok
    end

    private

      def login_params
        params.permit(:email, :password)
      end
  end
end
