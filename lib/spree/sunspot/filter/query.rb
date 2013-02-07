module Spree
  module Sunspot
    module Filter

      class Query
        attr_accessor :query_params

        def initialize(query)
          unless query.nil?
            @query_params = query.map do |key, value|
              Param.new(key, value)
            end
          end
        end

        def build_search(search)
          @query_params.each{|p| p.build_search_query(search) }
          search
        end

        def build_url
          @query_params.collect{ |p| p.to_param }.join('|')
        end

        def has_filter?(filter, value)
          @query_params.select{ |p| p.has_filter?(filter, value) }.any?
        end
      end

    end
  end
end
