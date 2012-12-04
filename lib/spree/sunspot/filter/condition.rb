module Spree
  module Sunspot
    module Filter

      class Condition
        attr_accessor :value
        attr_accessor :condition_type
        attr_accessor :source

        SPLIT_CHAR = ','
        GREATER_THAN = 1
        BETWEEN = 2
        EQUAL = 3

        def multiple?
          value.kindof?(Array)
        end

        def initialize(source, pcondition)
          @source = source
          range = pcondition.split(SPLIT_CHAR)
          if range.size > 1
            if range[1] == '*'
              @value = range[0].to_f
              @condition_type = GREATER_THAN
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
              "#{value.to_i.to_s}#{SPLIT_CHAR}*"
            when BETWEEN
              "#{value.first.to_i.to_s}#{SPLIT_CHAR}#{value.last.to_i.to_s}"
            when EQUAL
              value.to_s
          end
        end

        def build_search_query(query)
          case condition_type
            when GREATER_THAN
              query.with(source.search_param).greater_than(value)
            when BETWEEN
              query.with(source.search_param).between(value)
            when EQUAL
              query.with(source.search_param, value)
          end
          query
        end
      end

    end
  end
end
