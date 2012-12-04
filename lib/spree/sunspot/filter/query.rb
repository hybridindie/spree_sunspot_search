module Spree
  module Sunspot
    module Filter

      class Query
        attr_accessor :params
        SPLIT_CHAR = '|'
        PARAM_SPLIT_CHAR = '='
        def initialize(query)
          unless query.nil?
            qparams = query.split(SPLIT_CHAR)
            @params = qparams.map do |qp|
              display_name, values = qp.split(PARAM_SPLIT_CHAR)
              source = Spree::Sunspot::Setup.filters.filter_for(display_name)
              Spree::Sunspot::Filter::Param.new(source, values) unless values.nil?
            end
          end
        end

        def build_search(search)
          @params.each{|p| p.build_search_query(search) }
          search
        end

        def build_url
          @params.collect{|p| p.to_param}.join(SPLIT_CHAR)
        end

        def has_filter?(filter, value)
          @params.select{|p| p.has_filter?(filter, value)}.any?
        end
      end

    end
  end
end
