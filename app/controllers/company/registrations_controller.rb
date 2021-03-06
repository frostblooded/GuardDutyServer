class Company
  # A controller which manages all actions for registering a company
  class RegistrationsController < Devise::RegistrationsController
    before_action :require_no_authentication, only: [:new, :create, :cancel]
    before_action :authenticate_scope!, only: [:edit, :update, :destroy]
    before_action :configure_permitted_parameters

    # GET /resource/sign_up
    def new
      add_breadcrumb t('devise.registrations.new.title'), new_company_registration_path
      super
    end

    # POST /resource
    # def create
    # end

    # GET /resource/edit
    def edit
      add_breadcrumb t('settings.index.title'), settings_path
      add_breadcrumb t('settings.index.edit_credentials'), edit_company_registration_path
      super
    end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password, :pasword_confirmation)
      end
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.for(:account_update) << :attribute
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
