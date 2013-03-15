SpreeSunspotSearch
==================

Adds Solr search to Spree using [Sunspot](https://github.com/sunspot/sunspot).

This is compatible with Spree 1.2. I haven't tested it below that.


Install
=======

I make the assumption that you have a functioning Spree store and are just extending the search capabilities with Sunspot/Solr

Add spree_sunspot_search to your Gemfile and run bundler.

```ruby
gem 'spree_sunspot', github: 'jbrien/spree_sunspot_search'
```

add the following to the Gemfile if you are not using another solr install locally for testing and development. The rake tasks for starting and stop this for development are included automatically for your use.

```ruby
group :test, :development do
  gem 'sunspot_solr'
end
```

Install the sunspot.yml file from Sunspot and the spree_sunspot and spree_sunspot_filters initializers.

```ruby
rails g spree:sunspot:install
```

Running
=======

Start up Solr (bundled with Sunspot's install)

```ruby
rake sunspot:solr:run
```

Build the index for the first time

```ruby
rake sunspot:reindex
```

Setup and Customize the Index and Filters/Facets
------------------------------------------------

The spree_sunspot.rb initializer is a simple Sunspot definition just as defined by [Sunspot](https://github.com/sunspot/sunspot). This adds the searchable method to the Spree::Product model.

The meat of this extension is in the spree_sunspot_filters.rb initializers file. Here are all your facets / filtering are setup.

* search_param - is the field in the index that you want to be treated as a facet.
* search_condition - is the conjunction / disjunction to use. Acceptable values are :all / :any (At this time your :any is evaluated against the result of :all) as seen below.

```ruby
condition.all_of do
  filter_all_condition
  condition.any_of do
    filter_any_conditions
  end
end
```

Value is an array of fixed values for a filter. This is best used with Pricing as seen below.

Ranges are supported in values and translated to Solr's search. Zeros (0) are translated to stars(*) to allow for min/max results.

```ruby
filters.add do |f|
  f.search_param = 'price'
  f.search_condition = :all
  f.values {[
    0..25,
    26..50,
    51..75,
    76..0
  ]}
end
```

Performing the Searches within Spree
------------------------------------

Setup a Spree Searcher with:

```ruby
@searcher = Spree::Config.searcher_class.new(params)
```

Then retrieve the products from Solr:

```ruby
@products = @searcher.retrieve_products
```

This returns the Solr results.

_please note below is going to be changing and simplified greatly_

Sunspot returns a lot more information with the results which have been made available with the solr_search method

```ruby
@searcher.solr_search
```

Pagination
----------

Spree Sunspot observes Kaminari's params and Spree's Preferences for per_page

Showing and Navigation through Facets
-------------------------------------
Facets views based on default index and using HAML for clarity

```ruby
- @searcher.solr_search.facet(:taxon_ids).rows.each do |row|
  %div
    = link_to( nested_taxons_path( @taxon.permalink, s: { category_ids: row.value } ) ) do
      = row.instance.name
      = row.count
```

We pull the facets for the results using Sunspot's facet method. Spree Sunspot Search expects a Hash with an 's' key to store the facets to be searched against. Such as:

```ruby
s: { taxon_ids: 1 }
```

values can also be an array

```ruby
s: { taxon_ids: [ 1, 2, 4 ] }
```

you obviously can have multiple facets too.

```ruby
s: { taxon_ids: [ 1, 2, 4 ], price: 0..25 }
```

Sorting
-------

Spree Sunspot Search looks for an :order_by param for sorting. It must have a value relating to an indexed field and direction comma separated.

```ruby
order_by: 'taxon_ids, asc'
```

asc and desc are the acceptable directions; ascending and descending respectively.

TODOs
=====

* Finish Similar Products that is in the works
* Major code cleanup (due to development has been client driven)
* Tests
* Better Conjunction / Disjunction Configs for Spree
* Inclusion of Failover support for replicated Solr servers
* Support for Solr 4.x (and subsequent Sunspot contribs)

Testing
=======

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

Inspired and Expanded from My Original Extension and The work begun by [five18pm](https://github.com/five18pm/spree-sunspot)
Copyright (c) 2012-13 John Brien Dilts, released under the New BSD License.
