module Admin
  class BrandPolicy < ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      @user = user
      @record = record
    end

    def index?
      user.admin? || user.super_admin?
    end

    def create?
      user.admin? || user.super_admin?
    end

    def update?
      create?
    end
  end
end
