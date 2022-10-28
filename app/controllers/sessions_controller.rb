class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(username: params[:username])
      if user.present? && user.authenticate(params[:password_digest])
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash[:alert] = "Invalid"
        redirect_to login_path
      end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Log out"
  end

end
