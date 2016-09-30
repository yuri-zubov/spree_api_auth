module Spree
  module Api
    module V1

      ProductsController.class_eval do
          def index
            @products = Spree::Product.all

            # Filter products by price if params exist
            if params.has_key?(:price_floor) and params.has_key?(:price_ceiling)
              @products = @products.price_between(params[:price_floor], params[:price_ceiling])
            end

            # Only get products from taxon (category) IDs in params, if they exists
            if params.has_key?(:in_taxons)
              taxon_ids = params[:taxon_ids].split(',')
              @products = @products.in_taxons(taxon_ids)
            end

            @products = @products.distinct.page(params[:page]).per(params[:per_page])
            expires_in 15.minutes, :public => true
            headers['Surrogate-Control'] = "max-age=#{15.minutes}"
            respond_with(@products)
          end
      end

    end
  end
end
