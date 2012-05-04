# Price ranges to be used for faceting
#   gets turned into a Range object for searching (MUST specify with a dash!!!)
unless defined?(PRODUCT_PRICE_RANGES)
  PRODUCT_PRICE_RANGES = ["0-25", "25-50", "50-100", "100-150"]
end

# Product Options for use with Faceting
#   gets turned to #{value}_option for the facet
unless defined?(PRODUCT_OPTION_FACETS)
  PRODUCT_OPTION_FACETS = [:color, :size]
end

# Product Properties for use with Faceting
#   gets turned to #{value}_property for the facet
unless defined?(PRODUCT_PROPERTY_FACETS)
  # product properties retrieved using the new Spree::Product#property
  PRODUCT_PROPERTY_FACETS = [:brand]
end

unless defined?(PRODUCT_FIELDS)
  PRODUCT_FIELDS = [
    # boost gives the product title a bit of a priority
    { :type => :text, :name => :name, :opts => { :boost => 2.0 } },
    :description,
    { :type => :float, :name => :price }
  ]
end

unless defined?(PRODUCT_OTHER_FACETS)
  # custom facets defined as methods directly on Spree::Product
  PRODUCT_OTHER_FACETS = [:author_list]
end

unless defined?(PRODUCT_SHOW_FACETS)
  # facets that have already been created and should be displayed
  # in the suggestions partial
  PRODUCT_SHOW_FACETS = [:taxon_name]
end

unless defined?(PRODUCT_SORT_FIELDS)
  PRODUCT_SORT_FIELDS = {
    :score => :desc,
    :price => [:asc, :desc],
  }
end