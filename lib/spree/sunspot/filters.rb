module Spree
  module Sunspot
    class Filters
      attr_accessor :filters
  
      def initialize
        @filters = []
      end
  
      def add(&blk)
        filter = Spree::Sunspot::Filter::Filter.new
        yield filter
        filter.finalize!
        filters << filter
      end
  
      def filter_for(display_name)
        @filters.select{|f| f.display_name == display_name or f.display_param == display_name }.first
      end
  
      def method_missing(method, *args)
        if @filters.respond_to?(method)
          @filters.send(method, *args)
        else
          super
        end
      end
    end
  end
end
