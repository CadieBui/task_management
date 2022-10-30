# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authorized
  helper_method :current_user
  
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

  def authorized
    redirect_to login_path, alert: "You are already logged in." unless session.include? :user_id
  end

end
