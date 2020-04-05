# frozen_string_literal: true
module Api
  class PasswordsController < ApiController

    def new

    end

    def create
      if params[:email].blank?
        return render status: :unprocessable_entity, json: { error: 'Email not present' }
      end
      @user = User.find_by(email: params[:email])
      # NB: Even if a user is not found we should return a successful response anyway so an attacker
      # will not be able to check whether certain email addresses are registered in the system
      if @user
        @user.generate_password_token!
        # UserMailer.reset_password(@user).deliver_later
      end
      render status: :ok
    end

    def update

    end

  end
end
