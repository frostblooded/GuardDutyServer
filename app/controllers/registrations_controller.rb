class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create]

	protected

		def configure_permitted_parameters
			devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:company_name, :email, :password) }
		  devise_parameter_sanitizer.permit(:sign_in) do |user_params|
    		user_params.permit(:company_name, :password)
			end
		end
end

end