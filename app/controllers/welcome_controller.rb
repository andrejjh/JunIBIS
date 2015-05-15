class WelcomeController < ApplicationController
def about
	@menu=4
end
def contact
	@menu=5
end
def index
	@menu=1
end
def change_locale
	l = params[:locale].to_s.strip.to_sym
	l = I18n.default_locale unless I18n.available_locales.include?(l)
	cookies.permanent[:educator_locale]= l
	redirect_to request.referer || root_url
end
end
