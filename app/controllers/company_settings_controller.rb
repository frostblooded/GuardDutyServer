class CompanySettingsController < ApplicationController
  def show
    @company_daily_mail = params[:YesOrNoButton]
  end
end
