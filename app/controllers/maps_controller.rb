class MapsController < ApplicationController
layout "empty"
before_action :set_menu

def set_menu
	@menu=3
end



	# GET /Map/1
		# GET /Map/1.xml
		def show
			@map = Map.find(params[:id])
			respond_to do |format|
				format.html { render :show, :layout => "map"}# show.html.erb
				format.json  { render json: @map }
			end
		end

		def index
			@maps = Map.order('id').all
			@legends = Legend.order('id').all
			@zooms = Zoom.order('id').all
			respond_to do |format|
				format.html { render :index, :layout => "application"}# index.html.erb
				format.json  { render json:  @maps }
			end
		end


def static
end
def dynamic
end
def places
end
def paths
end
def notes
end

end
