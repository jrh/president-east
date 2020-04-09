# frozen_string_literal: true
class ApiController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  include Pundit

  rescue_from ActionController::InvalidAuthenticityToken, with: :csrf_token_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  protect_from_forgery with: :exception

  before_action :set_csrf_cookie

  private
    # NB: JSON 'auth_message' is for login modal alert.  'message' is for app flash alert

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def set_csrf_cookie
      cookies["CSRF-TOKEN"] = form_authenticity_token
    end

    def csrf_token_invalid
      render status: :unauthorized, json: { auth_message: 'CSRF token invalid. Please login again' }
    end

    def authenticate_user
      render status: :unauthorized, json: { auth_message: 'You must be logged in to do that. Please login again' } unless current_user
    end

    def not_found
      render status: :not_found, json: { message: 'Record not found' }
    end

    def forbidden
      render status: :forbidden, json: { message: 'You do not have permission to do that' }
    end
end
