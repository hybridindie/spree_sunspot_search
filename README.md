SpreeSunspotSearch
==================

Adds Solr search to Spree using Sunspot.


Install
=======

I make the assumption that you have a functioning Spree store and are just extending the search capabilities with Sunspot/Solr

Add spree_sunspot_search to your Gemfile and run bundler.

gem 'spree_sunspot_search', git: 'git://github.com/jbrien/spree_sunspot_search.git'

add the following to the Gemfile if you are not using another solr install locally for testing and development. The rake tasks for starting and stop this for development are included automatically for your use.

group :test, :development do
  gem 'sunspot_solr'
end

bundle install

Install the solr.yml file from Sunspot.
rails g sunspot_rails:install

Copyright (c) 2011 John Brien Dilts, released under the New BSD License
