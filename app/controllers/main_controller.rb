# frozen_string_literal: true
class MainController < ApplicationController
  def home
    cookies["CSRF-TOKEN"] = form_authenticity_token
  end
end