module Mobile
  class SignupCompany < Grape::API
    helpers do
      def company_exists?
        Company.exists?(company_name: params[:company_name])
      end

      def passwords_match?
        params[:password] == params[:password_confirmation]
      end
    end

    resource :mobile do
      params do
        requires :company_name, type: String
        requires :email, type: String
        requires :password, type: String
        requires :password_confirmation, type: String
      end

      post :signup_company do
        error!('company name already exists', 400) if company_exists?
        error!('passwords don\'t match', 400) unless passwords_match?

        Company.create(company_name: params[:company_name],
                       email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])

        {success:true}
      end 
    end 
  end 
end