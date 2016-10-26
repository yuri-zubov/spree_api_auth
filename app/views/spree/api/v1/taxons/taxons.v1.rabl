attributes *taxon_attributes

node(:icon_url) { |t| t.icon.url if t.icon.present? }
node(:followed_by_current_user) { |t| t.followed_by?(@current_api_user) }

node :prototypes do |p|
  p.prototypes.map { |p| partial("spree/api/v1/prototypes/index", :object => p) }
end

node :taxons do |t|
  t.children.map { |c| partial("spree/api/v1/taxons/taxons", :object => c) }
end
