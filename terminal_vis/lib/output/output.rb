# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-21 19:08:37

require_relative '../data/data_set'
require_relative '../graphics/color_legend'

# Simple output for the terminal visualization
# @legend => color legend used for the output
class Output
    attr_reader :legend

    # Initialization with data set that should be visualized
    def initialize(data_set)
        @legend = ColorLegend.new(data_set.min_value, data_set.max_value)
    end

    # Reversed the data to print it in the correct occurence
    def print_data(data_set, meta_data)
        reversed_data = data_set.data.to_a.reverse.to_h

        reversed_data.each_value { |row|
            print "  "
            row.each { |value| print legend.print_color_for_data(value) }
            puts ""
        }

        print "\nY-axis with #{meta_data.domain_y.name} from " \
             "#{meta_data.domain_y.lower}"
        puts " up to #{meta_data.domain_y.upper} and steprange" \
             " #{meta_data.domain_y.step}."
        print "X-axis with #{meta_data.domain_x.name} from " \
              "#{meta_data.domain_x.lower}"
        puts " up to #{meta_data.domain_x.upper} and steprange" \
             " #{meta_data.domain_x.step}."

        puts "Dataset: #{meta_data.name}"

        legend.print_color_legend
    end
end
