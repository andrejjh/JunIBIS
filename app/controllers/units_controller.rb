class UnitsController < ApplicationController

# GET /Unit/1
  # GET /unit/1.xml
  def show
    @armies= Unit.armies.order('code').all
    @unit = Unit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unit }
    end
  end

  def resolve
    @armies= Unit.armies.order('code').all
    @unit = Unit.find_by code: (params[:id])
    render :action => 'show'
  end
end
