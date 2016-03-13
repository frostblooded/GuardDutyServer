class UsersController < ApplicationController
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
end
