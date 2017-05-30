class Company
  class ConfirmationsController < Devise::ConfirmationsController
    # GET /resource/confirmation/new
    def new
      add_breadcrumb t('devise.sessions.new.title'), new_company_session_path
      add_breadcrumb t('devise.confirmations.new.title'), new_company_confirmation_path
      super
    end

    # POST /resource/confirmation
    # def create
    #   super
    # end

    # GET /resource/confirmation?confirmation_token=abcdef
    # def show
    #   super
    # end

    # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end
  end
end
