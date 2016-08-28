# A controller which handles sites' actions
class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def index
    @sites = current_company.sites
  end

  def show
    @site = Site.find params[:id]
    @workers = current_company.workers
  end

  def update
    @site = Site.find params[:id]
    time_regex = AttendanceCheckRailsapp::Application.config.time_regex

    if !(params[:shift_start] =~ time_regex)
      flash[:danger] = 'Invalid shift start format. '
    end

    if !(params[:shift_end] =~ time_regex)
      flash[:danger] += 'Invalid shift end format.'
    end

    if flash.empty?
      @site.settings(:call).interval = params[:call_interval]
      @site.settings(:shift).start = params[:shift_start]
      @site.settings(:shift).end = params[:shift_end]
      @site.save!

      flash[:success] = 'Settings saved'
    end

    redirect_to site_path(@site)
  end

  def create
    @site = current_company.sites.create(site_params)
    
    if @site.save
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
