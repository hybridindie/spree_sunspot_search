module Spree
  module Sunspot
    module Filter

      class Filter
        include ActionView::Helpers::NumberHelper
        attr_accessor :search_param
        attr_accessor :search_condition
        attr_accessor :values
        attr_accessor :param_type

        def initialize
          @values = []
        end

        def values(&blk)
          @values = yield if block_given?
          @values
        end

        def display?
          !values.empty?
        end

        def search_param
          @search_param.to_sym
        end

        def search_condition
          @search_condition
        end

        def html_values
          case param_type.to_s
          when "Range"
            values.collect do |range|
              if range.first == 0
                { :display => "Under #{number_to_currency(range.last, :precision => 0)}", :value => "#{range.first},#{range.last}" }
              #TODO: needs removed we are no longer using IGNORE_MAX
              elsif range.last == Spree::Sunspot::Setup::IGNORE_MAX
                { :display => "#{number_to_currency(range.first, :precision => 0)}+", :value => "#{range.first},*" }
              else
                { :display => "#{number_to_currency(range.first, :precision => 0)} - #{number_to_currency(range.last, :precision => 0)}",
                  :value => "#{range.first},#{range.last}" }
              end
            end
          else
            values.collect do |value|
              { :display => value, :value => value }
            end
          end
        end

        def finalize!
          raise ArgumentError.new("search_param is nil") if search_param.nil?
          @param_type ||= values[0].class unless values.empty?
        end
      end
      
    end
  end
end
