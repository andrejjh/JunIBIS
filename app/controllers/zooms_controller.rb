class ZoomsController < ApplicationController
layout "zoom"
before_action :set_menu

def set_menu
	@menu=3
end

def index
	@zooms = Zoom.order('id').all
	respond_to do |format|
		format.html  ## index.html.erb
		format.json  { render json:  @zooms }
	end
end

	# GET /Map/1
		# GET /Map/1.xml
		def show
			@zoom = Zoom.find(params[:id])
			respond_to do |format|
				format.html # show.html.erb
				format.json  { render json: @zoom }
			end
		end

end
