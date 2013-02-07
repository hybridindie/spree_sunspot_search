module Spree
  module Sunspot
    module Filter

      class Condition
        attr_accessor :value
        attr_accessor :condition_type
        attr_accessor :exclusion
        attr_accessor :field_param

        GREATER_THAN = 1
        LESS_THAN = 2
        BETWEEN = 3
        EQUAL = 4

        def multiple?
          value.kindof?(Array)
        end

        def initialize(source, pcondition)
          @field_param = source
          range = pcondition.split(',')
          if range.size > 1
            if range[1] == '*'
              @value = range[0]
              @condition_type = GREATER_THAN
            elsif range[0] == '*'
              @value = range[1]
              @condition_type = LESS_THAN
            else
              @value = Range.new(range[0], range[1])
              @condition_type = BETWEEN
            end
          else
            @value = pcondition
            @condition_type = EQUAL
          end
        end

        def to_param
          case condition_type
            when GREATER_THAN
              "#{value},*"
            when LESS_THAN
              "*,#{value}"
            when BETWEEN
              "#{value.first},#{value.last}"
            when EQUAL
              value.to_s
          end
        end

        def build_search_query(query)
          case condition_type
            when GREATER_THAN
              query.with(field_param.source).greater_than(value)
            when LESS_THAN
              query.with(field_param.source).less_than(value)
            when BETWEEN
              query.with(field_param.source).between(value)
            when EQUAL
              query.with(field_param.source, value)
          end
          query
        end
      end

    end
  end
end
