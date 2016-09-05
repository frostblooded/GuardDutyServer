module API
  module V1
    # Represents the sites' routes for the API
    class Routes < Grape::API
      params do
        requires :positions
      end

      # Create a new route
      post :routes do
        authorize! :manage, Route

        r = params_site.routes.create!(name: 'test route')

        params['positions'].each_with_index do |p, index|
          r.positions.create! longitude: p['longitude'],
                              latitude: p['latitude'],
                              index: index
        end

        { success: true }
      end
    end
  end
end
