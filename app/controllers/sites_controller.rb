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
      update_settings
      flash[:success] = t '.success'
    end

    flash[:danger] = @errors.join(', ') unless @errors.empty?
    redirect_to site_path(@site)
  end

  def update_settings
    @site.call_interval = params[:call_interval]
    @site.shift_start = params[:shift_start]
    @site.shift_end = params[:shift_end]
    @site.save!
  end

  def create
    @site.company = current_company

    if @site.save
      flash[:success] = t '.success'
      redirect_to sites_path
    else
      render 'new'
    end
  end

  def destroy
    @site.destroy
    flash[:success] = t '.success'
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
    duplicates = params[:workers].select do |w|
      w if params[:workers].count(w) > 1
    end

    duplicates.uniq!

    duplicates.each do |d|
      @errors << t('.duplicate_worker', worker: d)
    end
  end

  def remove_workers
    @site.site_worker_relations.each do |swr|
      swr.destroy unless params[:workers].include? swr.worker.name
    end
  end

  def remove_all_workers
    @site.site_worker_relations.each(&:destroy)
  end

  def add_workers
    params[:workers].uniq.each do |name|
      worker = @site.company.workers.find_by name: name

      if !worker
        @errors << t('.inexistent_worker', worker: name)
      else
        @site.workers << worker unless @site.workers.include? worker
      end
    end
  end
end
