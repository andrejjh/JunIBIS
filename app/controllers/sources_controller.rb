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

#	def download
#		@source = Source.find(params[:id])
#		if File.exists?(@source.url) and File.readable?(@source.url)
#			send_file (@source.url)
#		else
#			redirect_to :back, notice: 'Unfortunately the requested file is not readable or cannot be located.'
#		end
#	end

	def index
		@sourcegroups = Sourcegroup.order('id').all
		respond_to do |format|
			format.html # index.html.erb
			format.json  { render json: @sourcegroups }
		end
	end
	def books
		@sources= Source.books.order('id').all
		respond_to do |format|
			format.html
			format.json  { render json: @sources }
		end
	end
	def games
		@sources= Source.games.order('id').all
		respond_to do |format|
			format.html
			format.json  { render json: @sources }
		end
	end
	def maps
		@sources= Source.maps.order('id').all
		respond_to do |format|
			format.html
			format.json  { render json: @sources }
		end
	end
	def papers
		@sources= Source.papers.order('id').all
		respond_to do |format|
			format.html
			format.json  { render json: @sources }
		end
	end
	def zines
		@sources= Source.zines.order('id').all
		respond_to do |format|
			format.html # index.html.erb
			format.json  { render json: @sources }
		end
	end

end
