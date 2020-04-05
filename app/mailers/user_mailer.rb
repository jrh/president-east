# frozen_string_literal: true
class UserMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def send_password_reset(user)
    @user = user
    mail(to: @user.email, subject: 'Reset Your Password')
  end
end
