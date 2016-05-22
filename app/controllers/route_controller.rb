class RouteController < ApplicationController
  def new
  	@route = Route.new
  end

  def create
    @company = current_company
    @sites = Site.find(params[:site_id])
    @route = @sites.routes.create(route_params) 
    if @route.save
      redirect_to root_path, :notice => "Route added!"
    else
      render "new"
    end
  end

  def index
  end

  def route_params
    params.require(:route).permit(:name) #here is the problem
  end
end
