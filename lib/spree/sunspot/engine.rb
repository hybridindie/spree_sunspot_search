require 'spree/sunspot/setup'
require 'spree/sunspot/filter_support'
require 'spree_core'

module Spree
  module Sunspot
    class Engine < Rails::Engine
      require 'spree/core'
      isolate_namespace Spree
      engine_name 'spree_sunspot'

      config.autoload_paths += %W(#{config.root}/lib)

      # use rspec for tests
      config.generators do |g|
        g.test_framework :rspec
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      config.to_prepare &method(:activate).to_proc

      initializer "spree.sunspot.search_config", :after => "spree.load_preferences" do |app|
        Spree::BaseController.class_eval do
          include(Spree::Sunspot::FilterSupport)
          filter_support
        end

        app.config.spree.preferences.searcher_class = Spree::Sunspot::Search
      end

    end
  end
end
