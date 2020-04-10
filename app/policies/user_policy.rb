class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def show?
    current_user.id == user.id
  end

  def update?
    current_user.id == user.id
  end

  def change_password?
    update?
  end
end
