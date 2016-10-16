module Spree
  module Api
    module V1

      ProductsController.class_eval do

        def index
          @products = Spree::Product.all

          # Filter products by name or description
          if params.has_key?(:q)
            @products = @products.in_name_or_description(params[:q])
          end

          # Filter products  by  price. Both  parameters
          #  ('price_floor', 'price_ceiling are required
          #  for the filter to trigger
          if params.has_key?(:price_floor) and params.has_key?(:price_ceiling)
            @products = @products.price_between(params[:price_floor], params[:price_ceiling])
          end

          # Only get products from taxon (category) IDs
          # in params, if they exists
          if params.has_key?(:in_taxons)
            taxon_ids = params[:in_taxons].split(',').map(&:to_i)
            @products = @products.in_taxons(taxon_ids)
          end

          # Filter products by their option types (i.e., 'mens-basic-sizes')
          #  and  option  values (i.e.,  Small,  Medium,  Large, etc.). Both
          #  parameters are required for it to work.
          if params.has_key?(:option_type) and params.has_key?(:option_value)
            @products = @products.with_option_value(params[:option_type], params[:option_value])
          end

          # Pagination
          @products = @products.distinct.page(params[:page]).per(params[:per_page])

          # Set cache invalidation
          expires_in 15.minutes, :public => true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"

          # Respond with the products
          respond_with(@products)
        end

        # Allows users to add to their list of favorite products
        def add_favorite
          product = Spree::Product.find(params[:id])

          # Handle uniqueness exception if association already exists.
          begin
            product.users_who_favorited << current_api_user
            render "spree/api/v1/shared/success", status: 200
          rescue ActiveRecord::RecordNotUnique
            render "spree/api/v1/taxons/already_favorited", status: 400
          end
        end


        # Allows users to remove from their list of favorite products.
        def remove_favorite
          product = Spree::Product.find(params[:id])

          if product.favorited_by?(current_api_user)
            product.users_who_favorited.delete(current_api_user)
            render "spree/api/v1/shared/success", status: 200
          else
            render "spree/api/v1/products/not_favorited", status: 400
          end
        end

      end

    end
  end
end
