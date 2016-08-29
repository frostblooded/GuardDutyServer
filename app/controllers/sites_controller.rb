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
    update_workers @site

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

  # Yes, it is pretty stupid to remove all workers
  # and add again only the ones, which are passed
  # in the parameters...
  def update_workers(site)
    flash[:danger] = ''
    remove_workers site

    params[:workers].each do |name|
      worker = Worker.find_by name: name

      unless worker
        flash[:danger] += "Worker #{name} doesn't exist "
      else
        Worker.find_by(name: name).sites << site
      end
    end
  end

  def remove_workers(site)
    site.site_worker_relations.each do |swr|
      swr.destroy
    end
  end
end
