class SiteController < ApplicationController
	def new
		@site = Site.new
	end

	def index
    if current_company
      @company = current_company
      @site = @company.sites
    end
	end

  def show
    @site = Site.find(params[:id])
    @company = current_company
    @site.settings(:shift_start).shift_start
    @site.settings(:shift_end).shift_end
    
  end

  def update
    @site = Site.find(params[:id])
    @shift_start = params[:shift_start]
    @shift_end = params[:shift_end]

    @site.settings(:shift_start).shift_start = @shift_start
    @site.settings(:shift_start).save!

    @site.settings(:shift_end).shift_end = @shift_end
    @site.settings(:shift_end).save!

    flash[:success] = "Settings saved"
    redirect_to current_site_path
  end

  def create
    @company = current_company
    @site = @company.sites.create(site_params) 
    if @site.save
      redirect_to sites_path, :notice => "Site added!"
    else
      render "new"
    end
  end	

	private

  def site_params
    params.require(:site).permit(:name)
  end
end
