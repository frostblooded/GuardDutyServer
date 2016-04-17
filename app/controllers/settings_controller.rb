class SettingsController < ApplicationController
  def index
    @daily_mail = params[:button_output]
    @company = current_company

    if @daily_mail = "Yes"
      @company.settings(:daily_mail).send = "True"
    end
  end
end
