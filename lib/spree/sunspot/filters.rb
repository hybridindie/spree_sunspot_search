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
        @filters << filter
      end

      #def self.filter_for(name)
      #  @filters.select{|f| f.display_name == name || f.search_param == name }.first
      #end

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
