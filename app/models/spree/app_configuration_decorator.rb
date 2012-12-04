module Spree
  AppConfiguration.class_eval do
    preference :total_similar_products, :integer, :default => 10
  end
end