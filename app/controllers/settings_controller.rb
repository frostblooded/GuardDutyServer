class SettingsController < ApplicationController
  def index
    @daily_mail = params[:daily_mail]
    @company = current_company
    if @daily_mail == "True"
      @company.settings(:daily_mail).daily_mail = "True"
      @company.save!
    else
      @company.settings(:daily_mail).daily_mail = "False"
      @company.save!
    end
  end

  def update
    @company = current_company
    @daily_mail.update!
  end
end
