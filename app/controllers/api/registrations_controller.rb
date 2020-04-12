# frozen_string_literal: true
module Api
  class RegistrationsController < ApiController

    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        render status: :created, json: @user
        DevMailer.report_success('User account created', ["#{@user.first_name} #{@user.last_name}", @user.email, @user.company]).deliver_later
      else
        render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
      end
    end

    private

      def user_params
        params.require(:registration).permit(:first_name, :last_name, :email, :password, :password_confirmation, :company)
      end
  end
end
