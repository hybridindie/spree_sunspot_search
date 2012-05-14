module Spree
  module Search
    module SpreeSunspot

      class Search < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain : Spree::Core::Search::Base
        def retrieve_products
          conf = Spree::Search::SpreeSunspot.configuration

          @properties[:sunspot] = Sunspot.search(::Spree::Product) do
            # This is a little tricky to understand
            #     - we are sending the block value as a method
            #     - Spree::Search::Base is using method_missing() to return the param values
            conf.display_facets.each do |name|
              with("#{name}_facet", send(name)) if send(name)
              facet("#{name}_facet")
            end

            with(:price, Range.new(price.split('-').first, price.split('-').last)) if price
            facet(:price) do
              conf.price_ranges.each do |range|
                row(range) do
                  with(:price, Range.new(range.split('-').first, range.split('-').last))
                end
              end

              # TODO add greater than range
            end

            order_by sort.to_sym, order.to_sym
            with(:is_active, true)
            keywords(query)
            paginate(:page => page, :per_page => per_page)
          end

          self.sunspot.results
        end

        protected

        def prepare(params)
          super
          @properties[:query] = params[:keywords]
          @properties[:price] = params[:price]

          @properties[:sort] = params[:sort] || :score
          @properties[:order] = params[:order] || :desc

          # TODO taxon facet should use ID instead of name
          # TODO the taxon facet link shouls use the taxon permalink instead of a query string param

          # when taxon navigation is in place, Spree::TaxonsController passes :taxon
          # :taxon is the ID of the taxon
          unless params[:taxon].blank?
            taxon = Spree::Taxon.find(params[:taxon])
            @properties[:taxon_name] = taxon.name unless taxon.nil?
          end
          
          Spree::Search::SpreeSunspot.configuration.display_facets.each do |name|
            @properties[name] = params["#{name}_facet"] if @properties[name].blank? or !params["#{name}_facet"].blank?
          end

          # this is to allow easily breadcrumb display
          # TODO in the future this shoudl be cleaned up when taxon's are handled better
          if params[:taxon].blank? and not params['taxon_name_facet'].blank?
            @properties[:taxon] = Spree::Taxon.find_by_name(params['taxon_name_facet'])
          end
        end

      end

    end
  end
end