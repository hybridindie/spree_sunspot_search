module Spree
  module Sunspot
    module Filter

      class Query
        attr_accessor :qparams

        def initialize(query)
          unless query.nil?
            @qparams = query.map do |key, value|
              Param.new(key, value)
            end
          end
        end

        def build_search(search)
          @qparams.each{|p| p.build_search_query(search) }
          search
        end

        def build_url
          @qparams.collect{ |p| p.to_param }.join('|')
        end

        def has_filter?(filter, value)
          @qparams.select{ |p| p.has_filter?(filter, value) }.any?
        end
      end

    end
  end
end
