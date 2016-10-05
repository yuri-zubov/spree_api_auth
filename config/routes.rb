Spree::Core::Engine.add_routes do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resource :users do
        post :sign_up
        post :sign_in
        post :update_preferences
        post :email_availability_check
        get :get_user
      end

      post 'taxons/:id/follow', to: 'taxons#follow'
      post 'taxons/:id/unfollow', to: 'taxons#unfollow'
    end
  end
end
