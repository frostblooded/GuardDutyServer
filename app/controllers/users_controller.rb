class UsersController < ApplicationController
  before_filter :configure_permitted_parameters, :only => [:create]

	def new
		@user = User.new
	end

  def show
    @user = User.all
    # If this show page is only for the currently logged in user change it to @user = current_user
  end

  def destroy
  	sign_out
  	redirect_to root_path
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
    end
end
