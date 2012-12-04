Spree::Sunspot::Setup.configure do
  searchable :auto_index => true, :auto_remove => true do
    text :name, :boost => 2.0
    text :description, :boost => 1.2
    time :available_on
    integer :taxon_ids, :references => Spree::Taxon, :multiple => true do
      taxons.collect{|t| t.self_and_ancestors.map(&:id) }.flatten
    end
    string :taxon_names, :multiple => true do
      taxons.collect{|t| t.self_and_ancestors.map(&:name) }.flatten
    end
    float :price
    # Additional Examples
    #
    # string :category_names, :multiple => true do
    #   category = Spree::Taxon.find_by_permalink('categories')
    #   taxons.select{|t| t.ancestors.include?(category)}.collect{|t| t.self_and_ancestors.map(&:name)}.flatten - [category.name]
    # end
    # string :brand_name do
    #   brand = Spree::Taxon.find_by_permalink('brands')
    #   t = taxons.select{|t| t.ancestors.include?(brand)}.first
    #   t.name unless t.nil?
    # end
  end
end

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
