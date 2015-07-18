# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-18 12:48:15

require_relative '../graphics/string'
require_relative '../data/data_set'
require_relative '../data/data_series'
require_relative '../graphics/color_legend'

# Simple output for the terminal visualization
# @legend => color legend used for the output
class Output
    attr_reader :legend

    # Initialization with data set that should be visualized
    def initialize(data_series)
        @legend = ColorLegend.new(data_series.min_value, data_series.max_value)
    end

    # Reversed the data to print it in the correct occurence
    def print_data(data_set, index, meta_data)

        print_output_head(index, meta_data)

        # reverse the data to start with the highest y-value as the first
        # output line
        reversed_data = data_set.data.to_a.reverse.to_h

        reversed_data.each_value { |row|
            print "  "
            row.each { |value| print legend.print_color_for_data(value) }
            puts ""
        }

        puts ""
        legend.print_color_legend()

        puts "Dataset extreme values: %.3f; %.3f" %
                                      [data_set.min_value, data_set.max_value]
        print_meta_information(meta_data)

        puts "\n"
    end

    private

    # prints the meta information consisting of dataset name and informations
    # of the different dimensions
    def print_meta_information(meta_data)
        puts "\nDataset: #{meta_data.name}"

        print "\nX-axis with #{meta_data.domain_x.name} from %.1f up to %.1f" %
                            [meta_data.domain_x.lower, meta_data.domain_x.upper]
        puts " and steprange %.1f." % meta_data.domain_x.step
        print "Y-axis with #{meta_data.domain_y.name} from %.1f up to %.1f" %
                            [meta_data.domain_y.lower, meta_data.domain_y.upper]
        puts " and steprange %.1f." % meta_data.domain_y.step

        if (meta_data.domain_z != nil)
            print "Z-axis with #{meta_data.domain_z.name} from %.1f up to " %
                             meta_data.domain_z.lower
            puts "%.1f and steprange %.1f." %
                            [meta_data.domain_z.upper, meta_data.domain_z.step]
        end
    end

    # creates a headline before printing the data set based on the values
    # of the z dimension
    def print_output_head(index, meta_data)
        z_delta = index * meta_data.domain_z.step
        puts "\nPrinting dataset for %.2f" %
                    (meta_data.domain_z.lower + z_delta)
        puts "\n"
    end
end
