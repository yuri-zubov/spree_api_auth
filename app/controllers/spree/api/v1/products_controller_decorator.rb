module Spree
  module Api
    module V1

      ProductsController.class_eval do
        def index
          @products = Spree::Product.all

          # Filter products  by  price. Both  parameters
          #  ('price_floor', 'price_ceiling are required
          #  for the filter to trigger
          if params.has_key?(:price_floor) and params.has_key?(:price_ceiling)
            @products = @products.price_between(params[:price_floor], params[:price_ceiling])
          end

          # Only get products from taxon (category) IDs
          # in params, if they exists
          if params.has_key?(:in_taxons)
            taxon_ids = params[:in_taxons].split(',')
            @products = @products.in_taxons(taxon_ids)
          end

          # Filter products by their option types (i.e., 'mens-basic-sizes')
          #  and  option  values (i.e.,  Small,  Medium,  Large, etc.). Both
          #  parameters are required for it to work.
          if params.has_key?(:option_type) and params.has_key?(:option_value)
            @products = @products.with_option_value(params[:option_type], params[:option_value])
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
