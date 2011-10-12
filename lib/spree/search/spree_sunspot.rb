module Spree::Search
  class SpreeSunspot < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain :  Spree::Search::Base

    def retrieve_products
      products = Sunspot.search(Product) do
        # This is a little tricky to understand
        #     - we are sending the block value as a method
        #     - Spree::Search::Base is using method_missing() to return the param values
        PRODUCT_OPTION_FACETS.each do |option|
          with("#{option}_facet", send(option)) if send(option)

          facet("#{option}_facet")
        end

        PRODUCT_PROPERTY_FACETS.each do |prop|
          with("#{prop}_facet", send(prop)) if send(prop)

          facet("#{prop}_facet")
        end

        with(:price, Range.new(price.split('-').first, price.split('-').last)) if price
        facet(:price) do
          PRODUCT_PRICE_RANGES.each do |range|
            row(range) do
              with(:price, Range.new(range.split('-').first, range.split('-').last))
            end
          end
        end

        # Taxons by name
        with(:taxon_name, taxon_name) if taxon_name
        # Taxon via categories and the such
        with(:taxon, taxon) if taxon
        with(:is_active, true)

        keywords(query)

        paginate(:page => page, :per_page => per_page)
        
      end
      @properties[:products] = products
    end

    protected

    def prepare(params)
      super
      @properties[:taxon] = params[:taxon] unless params[:taxon].blank?
      #@properties[:taxon_name] = params[:taxon]
      @properties[:query] = params[:keywords]

      @properties[:price] = params[:price]
      
      PRODUCT_OPTION_FACETS.each do |option|
        @properties[option] = params["#{option}_facet"]
      end

      PRODUCT_PROPERTY_FACETS.each do |prop|
        @properties[prop] = params["#{prop}_facet"]
      end

    end

  end
end
