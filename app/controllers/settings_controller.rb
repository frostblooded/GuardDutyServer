class SettingsController < ApplicationController
  def index
    @daily_mail = params[:daily_mail]
    @company = current_company
    @shift_start = params[:shift_start]
    @shift_end = params[:shift_end]
  end

  def update
    @company = current_company
    @daily_mail = params[:daily_mail]
    @shift_start = params[:shift_start]
    @shift_end = params[:shift_end]

    if @daily_mail == "True"
      @company.settings(:daily_mail).daily_mail = "True"
      @company.settings(:daily_mail).save!
    else
      @company.settings(:daily_mail).daily_mail = "False"
      @company.settings(:daily_mail).save!
    end

    @company.settings(:shift_start).shift_start = @shift_start
    @company.settings(:shift_start).save!

    @company.settings(:shift_end).shift_end = @shift_end
    @company.settings(:shift_end).save!

    redirect_to settings_path
  end
end
