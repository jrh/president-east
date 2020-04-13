class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    user.id == record.id
  end

  def update?
    user.id == record.id
  end

  def change_password?
    update?
  end
end
