class MapsController < ApplicationController
layout "map"
before_action :set_menu

def set_menu
	@menu=3
end



	# GET /Map/1
		# GET /Map/1.xml
		def show
			@map = Map.find(params[:id])
			respond_to do |format|
				format.html # show.html.erb
				format.json  { render json: @map }
			end
		end
		def index
			@maps = Map.order('id').all
			respond_to do |format|
				format.html { render :index, :layout => "application"}# index.html.erb
				format.json  { render json:  @maps }
			end
		end



def map1
	@map = Map.find(1)
	render :show
end
def map2
end
def map3
end

end
