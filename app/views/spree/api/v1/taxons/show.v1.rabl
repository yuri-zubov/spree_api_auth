object @taxon
attributes *taxon_attributes

child :children => :taxons do
  attributes *taxon_attributes

  child @taxon.prototypes, root: :prototypes, object_root: false do
    attributes :id, :name
  end
end
