Product.class_eval do
  searchable do
    # Boost up the name in the results
    text :name, :boost => 2.0
    string :product_name, :stored => true do
      name.downcase.sub(/^(an?|the)\W+/, '')
    end

    text :description
    boolean :is_active, :using => :is_active?
    float :price

    integer :taxon_ids, :multiple => true, :references => Taxon
    string :taxon_name, :multiple => true do
      taxons.map(&:name)
    end

    PRODUCT_OPTION_FACETS.each do |option|
      string "#{option}_facet", :multiple => true do
        get_option_values(option.to_s).map(&:presentation)
      end
    end

    PRODUCT_PROPERTY_FACETS.each do |prop|
      string "#{prop}_facet", :multiple => true do
        get_product_property(prop.to_s)
      end
    end

    if respond_to?(:stores)
      integer :store_ids, :multiple => true, :references => Store
    end

  end

  def is_active?
    !deleted_at && available_on &&
      (available_on <= Time.zone.now) &&
        (Spree::Config[:allow_backorders] || count_on_hand > 0)
  end

  private

  def price_range
    max = 0
    PRODUCT_PRICE_RANGES.each do |range, name|
      return name if range.include?(price)
      max = range.max if range.max > max
    end
    I18n.t(:price_and_above, :price => max)
  end

  def get_product_property(prop)
    #p = Property.find_by_name(prop)
    #ProductProperty.find(:product_id => self.id, :property_id => p.id)
    pp = ProductProperty.first(:joins => :property, :conditions => {:product_id => self.id, :properties => {:name => prop.to_s}})
    pp.value if pp
  end

  def get_option_values(option_name)
    sql = <<-eos
      SELECT DISTINCT ov.id, ov.presentation
      FROM option_values AS ov
      LEFT JOIN option_types AS ot ON (ov.option_type_id = ot.id)
      LEFT JOIN option_values_variants AS ovv ON (ovv.option_value_id = ov.id)
      LEFT JOIN variants AS v ON (ovv.variant_id = v.id)
      LEFT JOIN products AS p ON (v.product_id = p.id)
      WHERE (ot.name = '#{option_name}' AND p.id = #{self.id});
    eos
    OptionValue.find_by_sql(sql)
  end
end
