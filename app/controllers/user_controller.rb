class UserController < ApplicationController

def new
	@user = User.new
end

def show
	@user = User.all
end
end
