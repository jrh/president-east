# frozen_string_literal: true
class User < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: /@/

  enum role: {
    customer: 0,
    admin: 1,
    super_admin: 9
  }

  def to_token_payload
    {
      sub: self.id,
      current_user: self
    }
  end

  def generate_password_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    save!
  end
end
