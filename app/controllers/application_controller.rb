class ApplicationController < ActionController::Base
before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

def set_locale
  if cookies[:educator_locale] && I18n.available_locales.include?(cookies[:educator_locale].to_sym)
    l = cookies[:educator_locale].to_sym
  else
    l = I18n.default_locale
    cookies.permanent[:educator_locale] = l
  end
  I18n.locale = l
end
end
