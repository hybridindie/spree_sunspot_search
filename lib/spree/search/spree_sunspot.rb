module Spree
  module Search
    class SpreeSunspot < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain :  Spree::Core::Search::Base
      def retrieve_products
        @properties[:sunspot] = Sunspot.search(::Spree::Product) do
          # This is a little tricky to understand
          #     - we are sending the block value as a method
          #     - Spree::Search::Base is using method_missing() to return the param values

          (PRODUCT_OPTION_FACETS + PRODUCT_PROPERTY_FACETS + PRODUCT_OTHER_FACETS + [:taxon_name]).each do |name|
            with("#{name}_facet", send(name)) if send(name)
            facet("#{name}_facet")
          end

          with(:price, Range.new(price.split('-').first, price.split('-').last)) if price
          facet(:price) do
            PRODUCT_PRICE_RANGES.each do |range|
              row(range) do
                with(:price, Range.new(range.split('-').first, range.split('-').last))
              end
            end
          end

          with(:is_active, true)
          keywords(query)
          paginate(:page => page, :per_page => per_page)
        end

        @properties[:products] = self.sunspot.results
      end

      protected

      def prepare(params)
        super
        @properties[:query] = params[:keywords]
        @properties[:price] = params[:price]
        
        (PRODUCT_OPTION_FACETS + PRODUCT_PROPERTY_FACETS + PRODUCT_OTHER_FACETS + PRODUCT_SHOW_FACETS).each do |name|
          @properties[name] = params["#{name}_facet"]
        end

      end

    end
  end
end
