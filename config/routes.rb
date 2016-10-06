Spree::Core::Engine.add_routes do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resource :users do
        post :sign_up
        post :sign_in
        post :update_preferences
        post :email_availability_check
        get :get_user
        get :favorite_products
      end

      # Endpoints for following and unfollowing brands.
      post 'taxons/:id/follow', to: 'taxons#follow'
      post 'taxons/:id/unfollow', to: 'taxons#unfollow'

      # Endpoints for adding and removing favorite products.
      post 'products/:id/add_favorite', to: 'products#add_favorite'
      post 'products/:id/remove_favorite', to: 'products#remove_favorite'
    end
  end
end
