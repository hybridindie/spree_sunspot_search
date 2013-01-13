module Spree
  module Sunspot
    module Filter

      class Condition
        attr_accessor :value
        attr_accessor :condition_type
        attr_accessor :source

        GREATER_THAN = 1
        LESS_THAN = 2
        BETWEEN = 3
        EQUAL = 4

        def multiple?
          value.kindof?(Array)
        end

        def initialize(source, pcondition)
          @source = source
          range = pcondition.split(',')
          if range.size > 1
            if range[1] == '*'
              @value = range[0].to_f
              @condition_type = GREATER_THAN
            elsif range[0] == '*'
              @value = range[1].to_f
              @condition_type = LESS_THAN
            else
              @value = Range.new(range[0].to_f, range[1].to_f)
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
              "#{value.to_i.to_s},*"
            when LESS_THAN
              "*,#{value.to_i.to_s}"
            when BETWEEN
              "#{value.first.to_i.to_s},#{value.last.to_i.to_s}"
            when EQUAL
              value.to_s
          end
        end

        def build_search_query(query)
          case condition_type
            when GREATER_THAN
              query.with(source.source).greater_than(value)
            when LESS_THAN
              query.with(source.source).less_than(value)
            when BETWEEN
              query.with(source.source).between(value)
            when EQUAL
              query.with(source.source, value)
          end
          query
        end
      end

    end
  end
end
