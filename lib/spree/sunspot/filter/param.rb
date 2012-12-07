module Spree
  module Sunspot
    module Filter

      class Param
        attr_accessor :source
        attr_accessor :conditions

        SPLIT_CHAR = ';'

        def initialize(source, pcondition)
          @source = source
          pconditions = pcondition.split(SPLIT_CHAR)
          this = self
          @conditions = pconditions.map{|p| Condition.new(this, p)}
        end

        def to_param
          value = @conditions.collect{|condition| condition.to_param}.join(SPLIT_CHAR)
          "#{display_name.downcase}#{Query::PARAM_SPLIT_CHAR}value"
        end

        def method_missing(method, *args)
          if source.respond_to?(method)
            source.send(method, *args)
          else
            super
          end
        end

        def has_filter?(filter, value)
          @source == filter and @conditions.select{|c| c.to_param == value}.any?
        end

        class << self

          def build_search_query(search, conditions)
            search.query.build do |query|
              if conditions.size > 0
                conditions.each do |condition, value|
                  # TODO: Get Ranges better supported; pieces are in place just need detected and implemented
                  with(condition, value)
                end
              else
                conditions[0].build_search_query(query)
              end
            end

            search
          end

        end

      end

    end
  end
end
