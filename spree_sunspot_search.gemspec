Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sunspot_search'
  s.version     = '0.60.1'
  s.summary     = 'Add Solr seach to Spree via the Sunspot gem'
  s.description = 'Sunspot and Spree have a wonderful baby'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'John Brien Dilts'
  s.email             = 'jdilts@railsdog.com'
  s.homepage          = 'http://www.railsdog.com'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  #s.add_dependency('spree_core', '>= 0.60.1')
  s.add_dependency('sunspot_rails', '>= 1.3.0rc4')
end
