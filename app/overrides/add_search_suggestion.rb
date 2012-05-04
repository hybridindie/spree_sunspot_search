Deface::Override.new(:virtual_path => "spree/products/index",
                      :name => "show_search_partials_suggestion",
                      :insert_top => "[data-hook='search_results']",
                      :partial => "spree/products/suggestion",
                      :disabled => false)
