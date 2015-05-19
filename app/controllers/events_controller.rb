class EventsController < ApplicationController
# GET /Event/1
	# GET /Event/1.xml
	def show
		@event = Event.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.json  { render json: @event }
		end
	end
	def index
		@events = Event.order('id').all
		respond_to do |format|
			format.html # index.html.erb
			format.json  { render json: @events }
		end
	end

end
