class Company
  # A controller which manages a company's sessions
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params
    before_action :lowercase_name

    def lowercase_name
      self.name = name.downcase
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
end
