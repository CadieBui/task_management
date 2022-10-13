# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_timezone

  # 將網站中的中文部分共用化
  def set_locale
    session[:locale] = params[:locale] if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)

    I18n.locale = session[:locale] || I18n.default_locale
  end

  # 設定 Rails 的時區
  def set_timezone
    Time.zone = "Taipei"
  end
end
