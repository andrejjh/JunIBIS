class ZoomsController < ApplicationController
layout "zoom", except: [:index]
before_action :set_menu

def set_menu
	@menu=3
end

def index
	@zooms = Zoom.order('id').all
	respond_to do |format|
		format.html # index.html.erb
		format.json  { render json: @zooms }
	end
end

	# GET /Zoom/1
		# GET /Zoom/1.xml
		def show
			@zoom = Zoom.find(params[:id])
			respond_to do |format|
				format.html # show.html.erb
				format.json  { render json: @zoom }
			end
		end

end
