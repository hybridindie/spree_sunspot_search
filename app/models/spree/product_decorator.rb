unless Spree::Sunspot::Setup.configuration.nil?
  Spree::Product.class_eval &Spree::Sunspot::Setup.configuration
end
