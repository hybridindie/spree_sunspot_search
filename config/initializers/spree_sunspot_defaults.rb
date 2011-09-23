unless defined?(PRODUCT_PRICE_RANGES)
  PRODUCT_PRICE_RANGES = {0..25 => "  Under $25", 25..50 => " $25 to $50",
                          50..100 => " $50 to $100", 100..200 => "$100 to $200"}
end
# Product Options for use with Faceting
#   gets turned to #{value}_option for the facet
unless defined?(PRODUCT_OPTION_FACETS)
  PRODUCT_OPTION_FACETS = [:color, :size]
end
# Product Properties for use with Faceting
#   gets turned to #{value}_property for the facet
unless defined?(PRODUCT_PROPERTY_FACETS)
  PRODUCT_PROPERTY_FACETS = [:brand]
end
