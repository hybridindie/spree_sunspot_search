module Spree
  module Sunspot
    module Filter

      class Filter
        include ActionView::Helpers::NumberHelper

        attr_accessor :display_name
        attr_accessor :exclusion
        attr_accessor :param_type
        attr_accessor :search_condition
        attr_accessor :search_param
        attr_accessor :values

        def initialize
          @values = []
        end

        def values(&blk)
          @values = yield if block_given?
          @values
        end

        def display?
          values.present?
        end

        def search_param
          @search_param.to_sym
        end

        def search_condition
          @search_condition
        end

        def exclusion
          @exclusion
        end

        def html_values
          case param_type.to_s
          when "Proc"
            values.first.call.collect do |value|
              { :display => value[0], :value => value[1], :orig_value => value[1] }
            end
          when "Range"
            values.collect do |range|
              if range.first == 0
                { :display => "Under #{number_to_currency(range.last, :precision => 0)}",
                  :value => "#{range.first},#{range.last}", :orig_value => range }
              elsif range.last == 0
                { :display => "#{number_to_currency(range.first, :precision => 0)}+",
                  :value => "#{range.first},*", :orig_value => range }
              else
                { :display => "#{number_to_currency(range.first, :precision => 0)} - #{number_to_currency(range.last, :precision => 0)}",
                  :value => "#{range.first},#{range.last}", :orig_value => range }
              end
            end
          else
            values.collect do |value|
              { :display => value, :value => value, :orig_value => value }
            end
          end
        end

        def finalize!
          raise ArgumentError.new("search_param is nil") if search_param.nil?
          raise ArgumentError.new("search_condition is nil") if search_condition.nil?
          @param_type ||= values[0].class unless values.empty?
        end
      end
      
    end
  end
end
