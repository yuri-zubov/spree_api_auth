module Spree
  module Api
    module V1

      TaxonsController.class_eval do
        # Allow for users to follow brands. Since
        # brands  are represented  by taxons,  we
        # join users to taxons.
        def follow
          taxon = Spree::Taxon.find(params[:id])

          # Handle uniqueness exception if
          # association already exists.
          begin
            taxon.users << current_api_user
            render "spree/api/v1/shared/success", status: 200
          rescue ActiveRecord::RecordNotUnique
            render "spree/api/v1/taxons/already_following", status: 400
          end
        end

        # Allow for users to remove themselves
        # from  following a particular  brand.
        def unfollow
          taxon = Spree::Taxon.find(params[:id])
          taxon.users.delete(current_api_user)
          render "spree/api/v1/shared/success", status: 200
        end
      end

    end
  end
end
