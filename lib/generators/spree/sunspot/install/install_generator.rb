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
      end

      def add_javascripts
        append_file "app/assets/javascripts/store/all.js", "//= require store/spree_sunspot\n"
        append_file "app/assets/javascripts/admin/all.js", "//= require admin/spree_sunspot\n"
      end

      def add_stylesheets
        inject_into_file "app/assets/stylesheets/store/all.css", " *= require store/spree_sunspot\n", :before => /\*\//, :verbose => true
        inject_into_file "app/assets/stylesheets/admin/all.css", " *= require admin/spree_sunspot\n", :before => /\*\//, :verbose => true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_sunspot'
      end

      def run_migrations
         res = ask "Would you like to run the migrations now? [Y/n]"
         if res == "" || res.downcase == "y"
           run 'bundle exec rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end
    end
  end
end
