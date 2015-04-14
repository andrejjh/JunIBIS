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
	@maps= Map.all
end
end
