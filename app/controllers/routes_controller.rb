# A controller which handles routes' actions
class RoutesController < ApplicationController
  def new
    @route = Route.new
  end

  def create
    @site = Site.find(params[:site_id])

    if @site.routes.create(route_params)
      flash[:success] = 'Route created'
      redirect_to site_route_index_path
    else
      render 'new'
    end
  end

  def index
    @routes = Site.find(params[:site_id]).routes
  end

  def route_params
    params.require(:route).permit(:name)
  end
end
