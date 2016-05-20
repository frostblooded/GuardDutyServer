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
