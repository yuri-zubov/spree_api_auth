attributes *taxon_attributes

node :prototypes do |p|
  p.prototypes.map { |p| partial("spree/api/v1/prototypes/index", :object => p) }
end

node :taxons do |t|
  t.children.map { |c| partial("spree/api/v1/taxons/taxons", :object => c) }
end
