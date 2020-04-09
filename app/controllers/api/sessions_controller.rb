# frozen_string_literal: true
module Api
  class SessionsController < ApiController

    def create
      @user = User.find_by_email(session_params[:email])
      if @user && @user.authenticate(session_params[:password])
        session[:user_id] = @user.id
        render status: :ok, json: @user
      else
        render status: 403, json: { auth_message: 'Invalid email or password' }
      end
    end

    def destroy
      session.delete(:user_id)
      @current_user = nil

      render status: :ok
    end

    private

      def session_params
        params.require(:session).permit(:email, :password)
      end
  end
end
