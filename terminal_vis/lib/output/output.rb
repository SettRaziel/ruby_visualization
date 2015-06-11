# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-11 20:34:38

require_relative '../data/data_set'
require_relative '../graphics/color_legend'

# Simple output for the terminal visualization
class Output
    attr_reader :legend

    # Initialization with data set that should be visualized
    def initialize(data_set)
        @legend = ColorLegend.new(data_set.min_value, data_set.max_value)
    end

    # Reversed the data to print it in the correct occurence
    def print_data(key, data_set)
        reversed_data = data_set.data.to_a.reverse.to_h
        reversed_data.each_value { |row|
            row.each { |value| print legend.print_color_for_data(value) }
            puts ""
        }

        puts "Dataset: #{key}"

        legend.print_color_legend
    end
end
