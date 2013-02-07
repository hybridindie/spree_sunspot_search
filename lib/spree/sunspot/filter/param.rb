module Spree
  module Sunspot
    module Filter

      class Param
        attr_accessor :source
        attr_accessor :conditions

        def initialize(source, pcondition)
          @source = source
          pconditions = pcondition.split(';')
          @conditions = pconditions.map{|p| Condition.new(self, p)}
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
          @source == filter && @conditions.select{|c| c.to_param == value}.any?
        end

        def build_search_query(search)
          search.build do |query|
            if @conditions.size > 0
              query.all_of do |cond|
                @conditions.each do |condition|
                  condition.build_search_query(cond) if wants_all?
                end

                query.any_of do |cond|
                  @conditions.each do |condition|
                    condition.build_search_query(cond) if wants_any?
                  end
                end

              end
            else

              @conditions[0].build_search_query(query)
            end
          end

          search
        end

        private
        def wants_any?
          Setup.query_filters.select{ |f| f.search_param == condition.value }.first.search_condition.eql?( :any )
        end

        def wants_all?
          Setup.query_filters.select{ |f| f.search_param == condition.value }.first.search_condition.eql?( :all )
        end
      end

    end
  end
end
