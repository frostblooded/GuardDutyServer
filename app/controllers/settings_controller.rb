# A controller that manages the settings of the logged in company
class SettingsController < ApplicationController
  def index
    @company = current_company
  end

  def update
    @errors = []
    save_recipients

    if @errors.empty?
      update_settings
      flash[:success] = t '.success'
    end

    flash[:danger] = @errors.join ', ' unless @errors.empty?
    redirect_to settings_path
  end

  def update_settings
    current_company.settings(:email).wanted = params[:email_wanted].present?
    current_company.settings(:email).time = params[:email_time]
    current_company.settings(:email).save!
  end

  def save_recipients
    current_company.settings(:email).recipients = [] if params[:email_wanted]

    if params[:recipients]
      params[:recipients].uniq.each { |r| handle_recipient r }
    end

    current_company.save!
  end

  def handle_recipient(recipient)
    if !(recipient =~ Rails.application.config.email_regex)
      @errors << t('.email_invalid', recipient: recipient)
    else
      current_company.settings(:email).recipients << recipient
    end
  end
end
