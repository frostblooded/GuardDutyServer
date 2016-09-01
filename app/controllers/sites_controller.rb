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
    @errors = []
    update_workers

    if @errors.empty?
      @site.settings(:call).interval = params[:call_interval]
      @site.settings(:shift).start = params[:shift_start]
      @site.settings(:shift).end = params[:shift_end]
      @site.save!

      flash[:success] = 'Settings saved'
    end

    flash[:danger] = @errors.join(', ') unless @errors.empty?
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
  def update_workers
    if params[:workers]
      remove_workers

      params[:workers].each do |name|
        worker = @site.company.workers.find_by name: name

        unless worker
          @errors << "Worker #{name} doesn't exist in this company"
        else
          worker.sites << @site
        end
      end
    end
  end

  def remove_workers
    @site.site_worker_relations.each do |swr|
      swr.destroy
    end
  end
end
