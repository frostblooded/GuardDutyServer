class Company
  class PasswordsController < Devise::PasswordsController
    # GET /resource/password/new
    def new
      add_breadcrumb t('devise.sessions.new.title'), new_company_session_path
      add_breadcrumb t('devise.passwords.new.title'), new_company_password_path
      super
    end

    # POST /resource/password
    # def create
    #   super
    # end

    # GET /resource/password/edit?reset_password_token=abcdef
    # def edit
    #   super
    # end

    # PUT /resource/password
    # def update
    #   super
    # end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
