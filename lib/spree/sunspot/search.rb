require 'spree/core/search/base'
require 'spree/sunspot/filter/filter'
require 'spree/sunspot/filter/condition'
require 'spree/sunspot/filter/param'
require 'spree/sunspot/filter/query'

module SpreeSunspot
  class Search < Spree::Core::Search::Base

    def query
      @filter_query
    end

    def solr_search
      @solr_search
    end

    def retrieve_products(*args)
      @products_scope = get_base_scope
      if args
        args.each do |additional_scope|
          case additional_scope
            when Hash
              scope_method = additional_scope.keys.first
              scope_values = additional_scope[scope_method]
              @products_scope = @products_scope.send(scope_method.to_sym, *scope_values)
            else
              @products_scope = @products_scope.send(additional_scope.to_sym)
          end
        end
      end

      curr_page = page || 1

      @products = @products_scope.includes([:master]).page(curr_page).per(per_page)
    end

    def similar_products(product, *field_names)
      products_search = Sunspot.more_like_this(product) do
        fields *field_names
        boost_by_relevance true
        paginate :per_page => total_similar_products * 4, :page => 1
      end

      # get active, in-stock products only.
      base_scope = get_common_base_scope
      hits = []
      if products_search.total > 0
        hits = products_search.hits.collect{|hit| hit.primary_key.to_i}
        base_scope = base_scope.where ["#{Spree::Product.table_name}.id in (?)", hits]
      else
        base_scope = base_scope.where ["#{Spree::Product.table_name}.id = -1"]
      end
      products_scope = @product_group.apply_on(base_scope)
      products_results = products_scope.includes([:images, :master]).page(1)

      # return top N most-relevant products (i.e. in the same order returned by more_like_this)
      @similar_products = products_results.sort_by{ |p| hits.find_index(p.id) }.shift(total_similar_products)
    end

    protected
    def get_base_scope
      base_scope = Spree::Product.active
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = base_scope.on_hand unless Spree::Config[:show_zero_stock_products]

      base_scope = add_search_scopes(base_scope)
      base_scope
    end

    def get_products_conditions_for(base_scope, query)
      @solr_search = Sunspot.new_search(Spree::Product) do |q|
        q.keywords(query)

        q.paginate(:page => 1, :per_page => Spree::Config[:products_per_page])

        Spree::Sunspot::Setup.filters.filters.each do |filter|
          q.facet(filter.search_param)

          # TODO: This needs moved out
          unless @properties[:filters].blank?
            conditions = Spree::Sunspot::Filter::Query.new(@properties[:filters]).params
            conditions.each do |condition, value|
              # TODO: Get Ranges better supported; pieces are in place just need detected and implemented
              q.with(condition, value)
            end
          end

        end
      end

      #unless @properties[:filters].blank?
      #  @filter_query = Spree::Sunspot::Filter::Query.new(@properties[:filters]).params
      #  @solr_search = Spree::Sunspot::Filter::Param.build_search_query(@solr_search, @filter_query)
      #end

      @solr_search.execute
      if @solr_search.total > 0
        @hits = @solr_search.hits.collect{|hit| hit.primary_key.to_i}
        base_scope = base_scope.where ["#{Spree::Product.table_name}.id in (?)", @hits]
      else
        base_scope = base_scope.where ["#{Spree::Product.table_name}.id = -1"]
      end

      base_scope
    end

    def prepare(params)
      super
      @properties[:filters] = params[:s] || params['s'] || []
      @properties[:total_similar_products] = params[:total_similar_products].to_i > 0 ? params[:total_similar_products].to_i : Spree::Config[:total_similar_products]
    end
  end
end