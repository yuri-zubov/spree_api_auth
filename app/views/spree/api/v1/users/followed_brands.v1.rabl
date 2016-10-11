object false
child @taxons => :taxons do
  attributes *taxon_attributes
  unless params[:without_children]
    extends "spree/api/v1/taxons/taxons"
  end
end
