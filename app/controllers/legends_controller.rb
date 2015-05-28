class LegendsController < ApplicationController
before_action :set_menu

def set_menu
	@menu=3
end
	# GET /Map/1
		# GET /Map/1.xml
		def show
			@legend = Legend.find(params[:id])
			respond_to do |format|
				format.html # show.html.erb
				format.json  { render json: @legend }
			end
		end

end
