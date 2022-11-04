class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:create, :new]

  def create
    user = User.find_by(username: params[:username])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('forms.create.login_success')
    else
      redirect_to login_path, notice: t('forms.invalid')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
