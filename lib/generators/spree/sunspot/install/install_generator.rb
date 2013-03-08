if not defined?(SunspotRails::Generators::InstallGenerator)
  require 'generators/sunspot_rails/install/install_generator.rb'
end

module Spree::Sunspot
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def invoke_sunspot_rails_generator
        SunspotRails::Generators::InstallGenerator.start
      end

      def add_initializer
        template "config/initializers/spree_sunspot.rb"
        template "config/initializers/spree_sunspot_filters.rb"
      end

    end
  end
end
