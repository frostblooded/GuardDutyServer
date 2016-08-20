# A controller which handles routes' actions
class RoutesController < ApplicationController
  def new
    @route = Route.new
  end

  def create
    @company = current_company
    @sites = Site.find(params[:site_id])

    if @sites.routes.create(route_params)
      redirect_to site_route_index_path, notice: 'Route added!'
    else
      render 'new'
    end
  end

  def index
    @company = current_company
    @sites = Site.find(params[:site_id])
    @route = @sites.routes
  end

  def route_params
    params.require(:route).permit(:name)
  end
end
