# frozen_string_literal: true
class UserMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def send_password_reset(user)
    @user = user
    if Rails.env.production?
      root = "https://www.presidenteastfood"
    else
      root = "http://localhost:3000"
    end
    @url = "#{root}/passwords/#{@user.reset_password_token}/edit"
    mail(to: @user.email, subject: 'Reset Your Password')
  end
end
