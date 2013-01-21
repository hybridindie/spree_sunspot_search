Spree::Sunspot::Setup.filters do |filters|
  # Maximum value would be ignored if the range maximum is set to
  # Spree::Sunspot::Setup::IGNORE_MAX
  filters.add do |f|
    f.search_param = 'price'
    f.display_name = 'Price'
    f.values { [0..10, 10..20, 20..30, 30..Spree::Sunspot::Setup::IGNORE_MAX] }
  end

  # Additional examples
  # filters.add do |f|
  #   f.search_param = 'category_name'
  #   f.display_name = 'Category'
  #   f.values { Spree::Taxon.find_by_permalink('categories').children.map(&:name) }
  # end
  #
  # filters.add do |f|
  #   f.search_param = 'brand_name'
  #   f.display_name = 'Brand'
  #   f.values { Spree::Taxon.find_by_permalink('brands').children.map(&:name) }
  # end
end
