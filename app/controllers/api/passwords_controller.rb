# frozen_string_literal: true
module Api
  class PasswordsController < ApiController

    # Email form
    def new
      render status: :ok
    end

    # Create token, send email
    def create
      if params.dig(:password, :email).blank?
        return render status: :unprocessable_entity, json: { error: 'Email not present' }
      end
      @user = User.find_by(email: params.dig(:password, :email))
      # NB: Even if a user is not found we should return a successful response anyway so an attacker
      # will not be able to check whether certain email addresses are registered in the system
      if @user
        @user.generate_password_token!
        UserMailer.send_password_reset(@user).deliver_later
      end
      render status: :ok
    end

    # New password form
    def edit
      render status: :ok
    end

    # Reset password
    def update
      @user = User.find_by(reset_password_token: params[:token])
      if Time.now > @user.reset_password_sent_at + 48.hours
        render status: :unauthorized, json: { error: 'A new password was not set within 48 hours. Please try again.' }
      else
        ActiveRecord::Base.transaction do
          @user.update(user_params)
          @user.clear_password_token!
        end
        session[:user_id] = @user.id
        render status: :ok, json: @user
      end
    end

    private

      def user_params
        params.require(:password).permit(:email, :password, :password_confirmation)
      end
  end
end
