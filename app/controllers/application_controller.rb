# A controller for some application-wide actions
class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  # Tell CanCan that current_company is used instead of current_user
  alias current_user current_company

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_company!, except: [:home, :contact]

  before_action :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_path
  end

  rescue_from ActionController::RoutingError, with: :render_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:name, :email, :password,
                                             :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in,
                                      keys: [:name, :password, :remember_me])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:email,
                                             :password,
                                             :password_confirmation,
                                             :current_password])
  end

  def set_locale
    if params[:locale].present?
      # Set company locale, so that it can be used
      # for when report needs to be send
      current_company.update!(locale: params[:locale]) if current_company

      I18n.locale = params[:locale]
    end
  end

  # Override the default url options to allow locale settings
  # in the url
  def default_url_options(_options = {})
    { locale: I18n.locale }
  end
end
