# A controller which handles sites' actions
class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def index
    @sites = current_company.sites
  end

  def show
    @site = Site.find(params[:id])
    @workers = current_company.workers
  end

  def update
    @site = Site.find(params[:id])

    @site.settings(:call).interval = params[:call_interval]
    @site.settings(:shift).start = params[:shift_start]
    @site.settings(:shift).end = params[:shift_end]
    @site.save!

    flash[:success] = 'Settings saved'
    redirect_to site_path(@site)
  end

  def create
    if current_company.sites.create(site_params)
      flash[:success] = 'Site created'
      redirect_to sites_path
    else
      render 'new'
    end
  end

  def destroy
    Site.find(params[:id]).destroy
    flash[:success] = 'Site deleted'
    redirect_to sites_path
  end

  private

  def site_params
    params.require(:site).permit(:name)
  end
end
