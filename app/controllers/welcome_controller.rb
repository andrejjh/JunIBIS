class WelcomeController < ApplicationController
def about
	@armies= Unit.armies.order('code').all
	@about=true
end
def contact
	@armies= Unit.armies.order('code').all
	@contact=true
end
def index
	@home=true
	@armies= Unit.armies.order('code').all
end
def change_locale
	@armies= Unit.armies.order('code').all
	l = params[:locale].to_s.strip.to_sym
	l = I18n.default_locale unless I18n.available_locales.include?(l)
	cookies.permanent[:educator_locale]= l
	redirect_to request.referer || root_url
end
end
