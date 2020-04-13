module Admin
  class UserPolicy < ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      user.admin? || user.super_admin?
    end

    def update?
      user.admin? || user.super_admin?
    end
  end
end
