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
end
