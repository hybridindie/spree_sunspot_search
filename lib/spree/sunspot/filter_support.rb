require 'spree/sunspot/search'

module Spree
  module Sunspot
    module FilterSupport
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def filter_support(options = {})
          additional_params = options[:additional_params_method]
          class_eval <<-EOV
            include Spree::Sunspot::FilterSupport::InstanceMethods
            helper_method :render_filter
          EOV
        end
      end

      module InstanceMethods
        def filter
          if params[:id]
            taxon = Spree::Taxon.find_by_linkname(params[:id])
            if taxon
              params.merge!(:taxon => taxon)
            end
          end
          if search_for_products
            respond_with(@products)
          end
        end

        def search_for_products(scope=nil)
          if (params[:filter].nil? or params[:filter].empty?) and !params[:source_url].nil?
            redirect_to params[:source_url]
            return false
          end
          @searcher = Spree::Config.searcher_class.new(params)
          if scope.nil?
            @products = @searcher.retrieve_products
          else
            @products = @searcher.retrieve_products(scope)
          end
          return true
        end

        def search_for_similar_products(product, *field_names)
          @searcher = Spree::Config.searcher_class.new(params)
          @similar_products = @searcher.similar_products(product, *field_names)
        end

        def filter_url_options
          object = instance_variable_get('@'+controller_name.singularize)
          if object
            case controller_name
            when "products"
              hash_for_product_path(object)
            when "taxons"
              hash_for_taxon_short_path(object)
            end
          else
            {}
          end
        end
      end

    end
  end
end

ActionController::Base.class_eval do
  include Spree::Sunspot::FilterSupport
end
