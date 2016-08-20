# A controller which handles sites' actions
class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def index
    @company = current_company
    @site = @company.sites
  end

  def show
    @site = Site.find(params[:id])
    @company = current_company
    @workers = @company.workers
    @attached_worker = @current_worker
  end

  def update
    @site = Site.find(params[:id])
    save_settings
    flash[:success] = 'Settings saved'
    redirect_to site_path(@site)
  end

  def create
    @company = current_company
    @site = @company.sites.create(site_params)

    if @site.save
      redirect_to sites_path, notice: 'Site added!'
    else
      render 'new'
    end
  end

  def destroy
    Site.find(params[:id]).destroy
    flash[:success] = 'Site destroyed'
    redirect_to sites_path
  end

  private

  def site_params
    params.require(:site).permit(:name)
  end

  def save_settings
    @site.settings(:call).interval = params[:call_interval]
    @site.settings(:attached_worker).name = params[:attached_worker]
    @site.settings(:shift).start = params[:shift_start]
    @site.settings(:shift).end = params[:shift_end]
    @site.save!
  end
end
