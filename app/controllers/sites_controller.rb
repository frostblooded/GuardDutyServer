# A controller which handles sites' actions
class SitesController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def index
    @sites = current_company.sites
  end

  def show
    @workers = current_company.workers
  end

  def update
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
    @site.company = current_company
    
    if @site.save
      flash[:success] = 'Site created'
      redirect_to sites_path
    else
      render 'new'
    end
  end

  def destroy
    @site.destroy
    flash[:success] = 'Site deleted'
    redirect_to sites_path
  end

  private

  def site_params
    params.require(:site).permit(:name)
  end

  def update_workers
    if params[:workers]
      remove_workers
      check_duplicate_workers
      add_workers
    else
      remove_all_workers
    end
  end

  def check_duplicate_workers
    duplicates = params[:workers].select { |w| w if params[:workers].count(w) > 1 }
    duplicates.uniq!

    duplicates.each do |d|
      @errors << "Worker '#{d}' was added several times"
    end
  end

  def remove_workers
    @site.site_worker_relations.each do |swr|
      unless params[:workers].include? swr.worker.name
        swr.destroy
      end
    end
  end

  def remove_all_workers
    @site.site_worker_relations.each { |swr| swr.destroy }
  end

  def add_workers
    params[:workers].uniq.each do |name|
      worker = @site.company.workers.find_by name: name

      if !worker
        @errors << "Worker #{name} doesn't exist in this company"
      elsif !@site.workers.include? worker
        @site.workers << worker
      end
    end
  end
end
