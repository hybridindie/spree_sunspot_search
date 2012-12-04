namespace :spree_sunspot do
  desc "Reindex all products"
  task :reindex => :environment do
    Spree::Product.remove_all_from_index!
    Spree::Product.reindex
    Sunspot.commit
  end
end
