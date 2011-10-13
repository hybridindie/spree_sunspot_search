namespace :spree_sunspot do
  desc "Copies initializer"
  task :install do
    source = File.join(File.dirname(__FILE__), '..', '..', 'config', 'initializers')
    destination = File.join(Rails.root, 'config', 'initializers')
    Spree::FileUtilz.mirror_files(source, destination)
  end
end
