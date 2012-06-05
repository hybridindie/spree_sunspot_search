SpreeSunspotSearch
==================

Adds Solr search to Spree using [Sunspot](https://github.com/sunspot/sunspot). This is a moving targer and is very beta and should be treated as such.

This is compatible with Spree 1.1. Untested on 1.0, but will probably work without too much modification


Install
=======

I make the assumption that you have a functioning Spree store and are just extending the search capabilities with Sunspot/Solr

Add spree_sunspot_search to your Gemfile and run bundler.

`gem 'spree_sunspot_search', git: 'git://github.com/jbrien/spree_sunspot_search.git'`

add the following to the Gemfile if you are not using another solr install locally for testing and development. The rake tasks for starting and stop this for development are included automatically for your use.

	group :test, :development do
		gem 'sunspot_solr'
	end


Install the solr.yml file from Sunspot.

`rails g sunspot_rails:install`

Copy the initializer and add `solr_sort_by` to `all.js`

`rails g spree_sunspot:install`

Running
=======

Start up Solr (bundled with Sunspot's install)

`rake sunspot:solr:run`

Build the index for the first time

`rake sunspot:reindex`

Customise the Facets Shown
--------------------------

Edit the initializer and specify you Product Properties, Product Options, and Price Ranges as an array.
The initializer should provide enough examples to get you started.

Testing
=======

TODO

TODOs
=====

* Add an automatic MAX value for price facets (e.g. Above <max_said_value>)
* Sorting by facet criteria and Solr analytics (Best result, Popular, etc.)
* Open the Sunspot DSL to utilise all the additional data and analytics available through Solr
* Get the Taxon browsing (e.g. Categories) to utilise the Solr data for speed boosts

Authors
=======
* @jbrien
* @iloveitaly

Copyright (c) 2011 John Brien Dilts, released under the New BSD License
