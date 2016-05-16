class SettingsController < ApplicationController
  def index
    if params[:daily_mail] == "true"
      @daily_mail == true
    end
    @company = current_company
    @shift_start = params[:shift_start]
    @shift_end = params[:shift_end]
  end


  def update
    @company = current_company
    @daily_mail = params[:daily_mail]
    @shift_start = params[:shift_start]
    @shift_end = params[:shift_end]
    @call_length = params[:call_length]

    if @daily_mail == "true"
      @company.settings(:daily_mail).daily_mail = "True"
      @company.settings(:daily_mail).save!
      @daily_mail == true
    else
      @company.settings(:daily_mail).daily_mail = "False"
      @company.settings(:daily_mail).save!
    end

    @company.settings(:shift_start).shift_start = @shift_start
    @company.settings(:shift_start).save!

    @company.settings(:shift_end).shift_end = @shift_end
    @company.settings(:shift_end).save!

    @company.settings(:call_length).call_length = @call_length
    @company.settings(:call_length).save!

    flash[:success] = "Settings saved"
    redirect_to settings_path
  end
end
