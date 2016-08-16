class SettingsController < ApplicationController
  def index
    if params[:daily_mail] == "true"
      @daily_mail == true
    end
    
    @company = current_company
  end

  def update
    @company = current_company
    @company.settings(:email).additional = params[:add_email]
    @company.settings(:email).daily = params[:daily_mail] ? true : false
    @company.settings(:email).time = params[:mail_time]
    @company.settings(:email).save!

    flash[:success] = "Settings saved"
    redirect_to settings_path
  end
end
