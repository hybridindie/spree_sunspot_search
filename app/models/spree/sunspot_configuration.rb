module Spree
  class SunspotConfiguration < Preferences::Configuration
    preference :facet_display_limit, :integer, :default => -1
  end
end
