module Spree
  module Sunspot
    module Filter

      class Param
        attr_accessor :source
        attr_accessor :conditions

        def initialize(source, pcondition)
          @source = source
          pconditions = String === pcondition ? pcondition.split(';') : pcondition
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
            end
          end

          search
        end

        private
        def wants_any?
          filter = Setup.query_filters.filters.select{ |f| f.search_param.to_s == self.source.to_s }.first
          if filter
            filter.search_condition.eql?( :any )
          else
            false
          end
        end

        def wants_all?
          filter = Setup.query_filters.filters.select{ |f| f.search_param.to_s == self.source.to_s }.first
          if filter
            filter.search_condition.eql?( :all )
          else
            # if filter is not present by default take it as :all
            true
          end
        end
      end

    end
  end
end
