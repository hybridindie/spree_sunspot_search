module Spree
  module Sunspot
    module Filter

      class Param
        attr_accessor :source
        attr_accessor :conditions

        def initialize(source, pcondition)
          @source = source
          pconditions = pcondition.split(';')
          this = self
          @conditions = pconditions.map{|p| Condition.new(this, p)}
        end

        def to_param
          value = @conditions.collect{|condition| condition.to_param}.join(';')
          "#{search_param}=#{value}"
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

        def build_search_query(search)
          search.build do |query|
            if @conditions.size > 0
              query.all_of do |cond|
                @conditions.each do |condition|
                  condition.build_search_query(cond) if Setup.filters.select{ |f| f.search_param == condition.value }.first.search_condition == :all
                end

                query.any_of do |cond|
                  @conditions.each do |condition|
                    condition.build_search_query(cond) if Setup.filters.select{ |f| f.search_param == condition.value }.first.search_condition == :any
                  end
                end

              end
            else

              @conditions[0].build_search_query(query)
            end
          end

          search
        end

      end

    end
  end
end
