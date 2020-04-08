# frozen_string_literal: true
class ApiController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  before_action :set_csrf_cookie

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def authenticate_user
      render status: :unauthorized, json: { error: 'Not authorized' } unless current_user
    end

    def set_csrf_cookie
      cookies["CSRF-TOKEN"] = form_authenticity_token
    end

end
