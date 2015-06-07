# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-04 09:36:41

require_relative '../data/data_set'
require_relative '../graphics/color_legend'

class Output
    attr_reader :legend

    def initialize(data_set)
        @legend = ColorLegend.new(data_set.min_value, data_set.max_value)
    end

    def print_data(data_set)
        reversed_data = data_set.data.to_a.reverse.to_h
        reversed_data.each_value { |row|
            row.each { |value| print legend.print_color_for_data(value) }
            puts ""
        }

        legend.print_color_legend
    end
end
