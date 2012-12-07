module Spree
  module Sunspot
    module Filter

      class Query
        attr_accessor :params

        def initialize(query)
          unless query.nil?
            @params = query.each do |key, value|
              Param.new(key, value)
            end
          end
        end

        def build_search(search)
          @params.build_search_query(search)
        end

        def build_url
          @params.collect{ |p| p.to_param }.join(SPLIT_CHAR)
        end

        def has_filter?(filter, value)
          @params.select{ |p| p.has_filter?(filter, value) }.any?
        end
      end

    end
  end
end
