Spree::Sunspot::Setup.query_filters do |filters|

  # Ranges can be Dates, Ints, or Floats:
  # filters.add do |f|
  #   f.search_param = 'price'
  #   # Can be :any (||) or :all (&&)
  #   f.search_condition = :any
  #   f.display_name = 'Price'
  #   f.values { [0..10, 10..20, 20..30] }
  # end

  # Pre load at runtime or specify items for restrictions:
  # filters.add do |f|
  #   f.search_param = 'category_name'
  #   f.search_condition = :any
  #   f.display_name = 'Category'
  #   f.values { Spree::Taxon.find_by_permalink('categories').children.map(&:name) }
  # end

  # Empty arrays eager load facets specified here:
  # filters.add do |f|
  #   f.search_param = 'brand_name'
  #   f.search_condition = :any
  #   f.display_name = 'Brand'
  #   f.values { [] }
  # end

  # Using a Proc to evaluate values at runtime rather than eager loading:
  # filters.add do |f|
  #   f.display_name = 'Categories'
  #   f.search_param = 'category_ids'
  #   f.search_condition = :any
  #   f.values { 
  #     Proc.new {
  #       Spree::Taxon.select{ |t| t.root.name.eql?('Categories') and t != t.root }.collect{ |taxon| [taxon.name, taxon.id] }
  #     }
  #   }
  # end

end
