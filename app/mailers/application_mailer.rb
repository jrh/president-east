# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'notification@presidenteastfood.com'
  layout 'mailer'
end
