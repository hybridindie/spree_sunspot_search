class SpreeSunspotSearchHooks < Spree::ThemeSupport::HookListener
	Deface::Override.new(:virtual_path => "products/index",
                     :name => "converted_search_results_343664108",
                     :insert_before => "[data-hook='search_results'], #search_results[data-hook]",
                     :partial => "products/facets",
                     :disabled => false)
end
