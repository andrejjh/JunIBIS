class SourcesController < ApplicationController
	before_action :set_menu

  def set_menu
    @menu=4
  end
# GET /Source/1
	# GET /Source/1.xml
	def show
		@source = Source.find(params[:id])
		respond_to do |format|
			format.html # show.html.erb
			format.json  { render json: @source }
		end
	end
	def index
		@sourcegroups = Sourcegroup.order('id').all
		respond_to do |format|
			format.html # index.html.erb
			format.json  { render json: @sourcegroups }
		end
	end

end
