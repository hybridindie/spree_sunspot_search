module SpreeSunspotSearch
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../templates/', __FILE__)

      def add_javascripts
        append_file "app/assets/javascripts/store/all.js", "//= require store/solr_sort_by\n"
      end

      def copy_initializer_file
        copy_file 'spree_sunspot_search.rb', "config/initializers/spree_sunspot_search.rb"
      end
    end
  end
end
