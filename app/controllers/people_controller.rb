class PeopleController < ApplicationController
# GET /Person/1
	# GET /Person/1.xml
	def show
		@armies= Unit.armies.order('code').all
		@person = Person.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @person }
		end
	end
end
