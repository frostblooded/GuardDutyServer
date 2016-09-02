# A controller for some application-wide actions
class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  # Tell CanCan that current_company is used instead of current_user
  alias_method :current_user, :current_company

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_company!, except: [:home, :contact]

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = exception.message
    redirect_to root_path
  end

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
end
