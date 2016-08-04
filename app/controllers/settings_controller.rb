class SettingsController < ApplicationController
  def index
    if params[:daily_mail] == "true"
      @daily_mail == true
    end
    @company = current_company
  end


  def update
    @company = current_company
    @daily_mail = params[:daily_mail]
    @additional_email = params[:add_email]
    @company.settings(:mail).additional = @additional_email
    @company.settings(:mail).save!

    if @daily_mail == "true"
      @company.settings(:mail).daily = "True"
      @company.settings(:mail).save!
    else
      @company.settings(:mail).daily = "False"
      @company.settings(:mail).save!
    end

    flash[:success] = "Settings saved"
    redirect_to settings_path
  end
end
