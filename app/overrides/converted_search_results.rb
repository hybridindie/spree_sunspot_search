Deface::Override.new(:virtual_path => "products/index",
                   :name => "converted_search_results",
                   :insert_before => "[data-hook='search_results'], #search_results[data-hook]",
                   :partial => "products/facets",
                   :disabled => false)
