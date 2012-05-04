require 'spree_core'
require 'sunspot_rails'

module SpreeSunspotSearch
  class Engine < Rails::Engine
    engine_name 'spree_sunspot_search'

    initializer "spree.solr_search.preferences", :after => "spree.environment" do |app|
      Spree::Config.searcher_class = Spree::Search::SpreeSunspot
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    # We have to reload the lib directory for dev mode
    # http://ileitch.github.com/2012/03/24/rails-32-code-reloading-from-lib.html
    config.watchable_dirs['lib'] = [:rb]

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare &method(:activate).to_proc
  end
end