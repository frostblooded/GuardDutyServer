class SettingsController < ApplicationController
  def index
    if params[:daily_mail] == "true"
      @daily_mail == true
    end
    
    @company = current_company
  end

  def update
    @company = current_company
    @company.settings(:mail).additional = params[:add_email]
    @company.settings(:mail).daily = params[:daily_mail] ? true : false
    @company.settings(:mail).time = params[:mail_time]
    @company.settings(:mail).save!

    flash[:success] = "Settings saved"
    redirect_to settings_path
  end
end
