module API
  class SignupCompany < Grape::API
    resource :mobile do
      params do
        requires :company_name, type: String
        requires :email, type: String
        requires :password, type: String
        requires :password_confirmation, type: String
      end

      post :signup_company do
        c = Company.create(company_name: params[:company_name],
                       email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])

        if !c.errors.messages.empty?
          return {error: c.errors.messages}
        end

        {success:true}
      end 
    end 
  end 
end