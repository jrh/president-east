class DevMailer < ApplicationMailer
  default template_path: "mailers/#{self.name.underscore}"

  def report_success(success_msg, details=[])
    @dev = User.select(:id, :email).find(Rails.application.credentials.dev_id)
    @success_msg = success_msg
    @details = details
    mail(to: @dev.email, subject: "APP Success! #{@success_msg}")
  end

  def report_error(error_msg, details=[])
    @dev = User.select(:id, :email).find(Rails.application.credentials.dev_id)
    @error_msg = error_msg
    @details = details
    mail(to: @dev.email, subject: 'APP Error! Something went wrong')
  end

  def report_warning(warning_msg, details=[])
    @dev = User.select(:id, :email).find(Rails.application.credentials.dev_id)
    @warning_msg = warning_msg
    @details = details
    mail(to: @dev.email, subject: "APP Warning! #{@warning_msg}")
  end
end
