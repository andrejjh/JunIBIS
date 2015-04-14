class SourcesController < ApplicationController
# GET /Source/1
	# GET /Source/1.xml
	def show
		@armies= Unit.armies.order('code').all
		@source = Source.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @source }
		end
	end
	def index
		@armies= Unit.armies.order('code').all
		@sources = Source.all
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @sources }
		end
	end

end
