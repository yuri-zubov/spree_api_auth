attributes :id, :name

node :option_types do |prototype|
  prototype.option_types.map { |ot| partial("spree/api/v1/option_types/index", :object => ot) }
end
