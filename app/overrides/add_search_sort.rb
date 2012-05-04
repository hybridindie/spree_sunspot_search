Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "add_sort_bar",
                     :insert_before => "#products",
                     :partial => 'spree/products/sort_bar')