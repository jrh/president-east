# frozen_string_literal: true
module Api
  class PasswordsController < ApiController

    # Email form
    def new
      render status: :ok
    end

    # Create token, send email
    def create
      if params[:email].blank?
        return render status: :unprocessable_entity, json: { error: 'Email not present' }
      end
      @user = User.find_by(email: params[:email])
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

    end

  end
end
