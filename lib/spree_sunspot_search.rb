require 'spree_core'
require 'spree_sunspot_search_hooks'
require 'sunspot_rails'

module SpreeSunspotSearch
  class Engine < Rails::Engine

    def self.activate
      if Spree::Config.instance
        Spree::Config.searcher_class = Spree::Search::SpreeSunspot
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
    config.autoload_paths += %W(#{config.root}/lib)
    
  end
end
