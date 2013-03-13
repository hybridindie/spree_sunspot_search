# The searchable definition within this configuration block will be evaluated by Spree::Product.
# Any fields you wish to add text or attribute indexes for should be defined here.
# See the Sunspot README for more info: https://github.com/sunspot/sunspot
Spree::Sunspot::Setup.configure do
  searchable :auto_index => true, :auto_remove => true do
    text :name, :boost => 2.0
    text :description, :boost => 1.2
    time :available_on
    integer :taxon_ids, :references => Spree::Taxon, :multiple => true do
      taxons.collect{|t| t.self_and_ancestors.map(&:id) }.flatten
    end
    string :taxon_names, :references => Spree::Taxon, :multiple => true do
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
