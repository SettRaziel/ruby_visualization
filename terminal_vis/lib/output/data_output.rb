# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-01 11:13:40

require_relative '../graphics/string'
require_relative '../data/data_set'
require_relative '../data/data_series'
require_relative '../graphics/color_legend'

# Simple data output for the terminal visualization
class DataOutput

    # reverses the data to print it in the correct occurence
    def self.print_data(data_series, index, meta_data,
                                                with_extreme_values=false)

        data_set = data_series.series[index]
        legend = ColorLegend.new(data_series.min_value, data_series.max_value)
        print_output_head(index, meta_data)

        # reverse the data to start with the highest y-value as the first
        # output line
        reversed_data = data_set.data.to_a.reverse.to_h

        reversed_data.each_value { |row|
            print "  "
            row.each { |value|
                if (with_extreme_values)
                    create_output_with_extremes(data_set,value,legend)
                else
                    print legend.create_output_string_for(value,'  ')
                end

            }
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
    def self.print_meta_information(meta_data)
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
    def self.print_output_head(index, meta_data)
        z_delta = index * meta_data.domain_z.step
        puts "\nPrinting dataset for %.2f" %
                    (meta_data.domain_z.lower + z_delta)
        puts "\n"
    end

    def self.create_output_with_extremes(data_set, value, legend)
        # create normal output
        if (value > data_set.min_value && value < data_set.max_value)
            print legend.create_output_string_for(value,'  ')
        # create output for minimum
        elsif (value == data_set.min_value)
            print legend.create_output_string_for(value,'--').
                  white.bright
        # create output for maximum
        else
            print legend.create_output_string_for(value,'++').
                  white.bright
        end
    end

end
