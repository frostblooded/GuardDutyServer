class RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, :only => [:create]

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:company_name, :email, :password) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:company_name, :email, :password) }
  		devise_parameter_sanitizer.for(:log_in) do |user_params| #This shit doesnt even work.....
    		user_params.permit(:company_name, :password)
  		end
	end
end