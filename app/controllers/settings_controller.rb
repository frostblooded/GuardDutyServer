# A controller the logged in company
class SettingsController < ApplicationController
  def index
    @company = current_company
  end

  def update
    @company = current_company
    @company.settings(:email).wanted = params[:email_wanted] ? true : false
    @company.settings(:email).time = params[:email_time]
    @company.settings(:email).save!

    flash[:success] = "Settings saved"
    redirect_to settings_path
  end
end
