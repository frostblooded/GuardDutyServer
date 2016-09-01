# A controller that manages the settings of the logged in company
class SettingsController < ApplicationController
  def index
    @company = current_company
  end

  def update
    @errors = []
    save_recipients

    if @errors.empty?
      current_company.settings(:email).wanted = params[:email_wanted] ? true : false
      current_company.settings(:email).time = params[:email_time]
      current_company.settings(:email).save!

      flash[:success] = 'Settings saved'
    end

    flash[:danger] = @errors.join ', ' unless @errors.empty?
    redirect_to settings_path
  end

  def save_recipients
    current_company.settings(:email).recipients = []

    params[:recipients].each do |r|
      unless r =~ Rails.application.config.email_regex
        @errors << "The email \"#{r}\" is invalid" 
      else
        current_company.settings(:email).recipients << r
      end
    end

    current_company.save!
  end
end
