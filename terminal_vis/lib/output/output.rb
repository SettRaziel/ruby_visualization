# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-15 08:22:36

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
    def print_data(data_set, index, meta_data)

        print_output_head(index, meta_data)

        reversed_data = data_set.data.to_a.reverse.to_h

        reversed_data.each_value { |row|
            print "  "
            row.each { |value| print legend.print_color_for_data(value) }
            puts ""
        }

        puts ""
        legend.print_color_legend()

        puts "\nDataset: #{meta_data.name}"

        print "\nY-axis with #{meta_data.domain_y.name} from " \
             "#{meta_data.domain_y.lower}"
        puts " up to #{meta_data.domain_y.upper} and steprange" \
             " #{meta_data.domain_y.step}."
        print "X-axis with #{meta_data.domain_x.name} from " \
              "#{meta_data.domain_x.lower}"
        puts " up to #{meta_data.domain_x.upper} and steprange" \
             " #{meta_data.domain_x.step}."
        if (meta_data.domain_z != nil)
            print "Z-axis with #{meta_data.domain_z.name} from " \
              "#{meta_data.domain_z.lower}"
            puts " up to #{meta_data.domain_z.upper} and steprange" \
                 " #{meta_data.domain_z.step}."
        end
        puts "\n"
    end

    private

    # creates a headline before printing the data set based on the values
    # of the z dimension
    def print_output_head(index, meta_data)
        z_delta = index * meta_data.domain_z.step
        puts "\nPrinting dataset for #{meta_data.domain_z.lower + z_delta}"
        puts "\n"
    end
end
