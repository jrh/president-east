# frozen_string_literal: true
class ApiController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include Pundit

  protect_from_forgery with: :exception

  rescue_from ActionController::InvalidAuthenticityToken, with: :csrf_token_invalid
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

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

    def csrf_token_invalid
      render status: :unauthorized, json: { error: 'CSRF token invalid' }
    end

    def not_authorized
      render status: :unauthorized, json: { error: 'You are not authorized to do that' }
    end
end
