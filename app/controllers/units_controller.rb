class UnitsController < ApplicationController
  before_action :set_menu

  def set_menu
    @menu=2
  end

  def index
    @armies= Unit.armies.order('code').all
  end

# GET /Unit/1
  # GET /unit/1.xml
  def show
    @unit = Unit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unit }
    end
  end

  def resolve
    @unit = Unit.find_by code: (params[:id])
    render :action => 'show'
  end
end
