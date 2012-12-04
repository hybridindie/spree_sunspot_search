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
          @conditions = pconditions.map{|p| Spree::Sunspot::Filter::Condition.new(this, p)}
        end

        def build_search_query(search)
          search.build do |query|
            if @conditions.size > 0
              query.any_of do |query|
                @conditions.each do |condition|
                  condition.build_search_query(query)
                end
              end
            else
              conditions[0].build_search_query(query)
            end
          end
          search
        end

        def to_param
          value = @conditions.collect{|condition| condition.to_param}.join(SPLIT_CHAR)
          "#{display_name.downcase}#{Spree::Sunspot::Filter::Query::PARAM_SPLIT_CHAR}value"
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
      end

    end
  end
end
