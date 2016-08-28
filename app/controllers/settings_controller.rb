# A controller that manages the settings of the logged in company
class SettingsController < ApplicationController
  def index
    @company = current_company
  end

  def update
    time_regex = AttendanceCheckRailsapp::Application.config.time_regex

    if !(params[:email_time] =~ time_regex)
      flash[:danger] = 'Invalid email time format'
    end

    if flash.empty?
      @company = current_company
      @company.settings(:email).wanted = params[:email_wanted] ? true : false
      @company.settings(:email).time = params[:email_time]
      @company.settings(:email).save!

      flash[:success] = 'Settings saved'
    end

    redirect_to settings_path
  end
end
