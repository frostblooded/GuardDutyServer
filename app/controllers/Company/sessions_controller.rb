class Company::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  before_save :lowercase_name

  def lowercase_name
    self.company_name = self.company_name.downcase
  end
  
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
