require 'sunspot_rails'
require 'spree/sunspot/filters'
require 'singleton'

module Spree
  module Sunspot
    class Setup
      include Singleton
      @@filters = Filters.new

      @@configuration = nil
      def self.configure(&blk)
        @@configuration = blk
      end

      def self.configuration
        @@configuration
      end

      def self.query_filters(&blk)
        yield @@filters if block_given?
        @@filters
      end
    end
  end
end
