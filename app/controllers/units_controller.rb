class UnitsController < ApplicationController
  before_action :set_menu

  def set_menu
    @menu=2
  end

  def index
    @armies= Unit.armies.order('code').all
    respond_to do |format|
      format.html # index.html.erb
      format.json  { render json: @units }
    end
  end

# GET /Unit/1
  # GET /unit/1.xml
  def show
    @unit = Unit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json  { render json: @unit }
    end
  end

  def resolve
    @unit = Unit.find_by code: (params[:id])
    respond_to do |format|
      format.html {render :action => 'show'}
      format.json  { render :json => @unit }
    end
  end
end
