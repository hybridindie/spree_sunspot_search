Spree::BaseHelper.module_eval do
  def link_to_facet(facet_name, facet_row)
    # if we are just linking to taxon, link to the perma

    if facet_name == :taxon_id
      # use seo_url when linking to a taxon
      link_to(facet_row.instance.name, seo_url(facet_row.instance), params.merge("page" => nil)) + " (#{facet_row.count})"
    else
      link_to(facet_row.value, params.merge("#{facet_name}_facet" => facet_row.value, "page" => nil)) + " (#{facet_row.count})"
    end
  end
end