class Company
  # A controller which manages a company's sessions
  class SessionsController < Devise::SessionsController
    before_action :configure_permitted_parameters

    # GET /resource/sign_in
    def new
      add_breadcrumb t('devise.sessions.new.title'), new_company_session_path
      super
    end

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
end
