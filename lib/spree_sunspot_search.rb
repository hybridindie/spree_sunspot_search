require 'spree_core'
require 'sunspot_rails'
require 'spree/search/spree_sunspot/configuration'

module Spree::SunspotSearch; end

module SpreeSunspotSearch
  class Engine < Rails::Engine
    engine_name 'spree_sunspot_search'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.sunspot_search.preferences", :after => "spree.environment" do |app|
      Spree::Config.searcher_class = Spree::Search::SpreeSunspot::Search
      Spree::SunspotSearch::Config = Spree::SunspotSearchConfiguration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end