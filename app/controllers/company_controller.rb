class CompanyController < ApplicationController
	def show
		@company = Company.all
	end
end
