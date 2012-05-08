Deface::Override.new(:virtual_path => "spree/shared/_products", 
                      :name => "add_sunspot_search_pagination", 
                      :replace => "code[erb-silent]:contains('if paginated_products.respond_to')",
                      :closing_selector => "code[erb-silent]:contains('end')",
                      :text => "<%= paginate @searcher.sunspot.hits %>")
