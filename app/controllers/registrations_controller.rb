class RegistrationsController < Devise::RegistrationsController
  #before_filter :configure_permitted_parameters, :only => [:create]

  #protected

  #  def configure_permitted_parameters
  #    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:company_name, :email, :password) }
  #    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:company_name, :email, :password) }
  #    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:company_name, :password, :remember_me) }
	#end
end