# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-02 10:16:18

require_relative '../graphics/string'
require_relative '../data/data_set'
require_relative '../data/data_series'
require_relative '../graphics/color_legend'

# Simple data output for the terminal visualization
class DataOutput

    # reverses the data to print it in the correct occurence
    def self.print_data(data_series, index, meta_data, with_extreme_values)

        data_set = data_series.series[index]
        legend = ColorLegend.new(data_series.min_value, data_series.max_value)
        print_output_head(index, meta_data)
        extreme_coordinates = {
            :maximum => Array.new(),
            :minimum => Array.new()
        }

        # reverse the data to start with the highest y-value as the first
        # output line
        reversed_data = data_set.data.to_a.reverse.to_h

        reversed_data.each_pair { |key, row|
            print "  "
            row.each_index { |index|
                if (with_extreme_values)
                    output = create_output_with_extremes(data_set,row[index],
                                                                      legend)
                    if (output == :maximum)
                        extreme_coordinates[:maximum] << [index, key]
                    elsif (output == :minimum)
                        extreme_coordinates[:minimum] << [index, key]
                    end
                else
                    print legend.create_output_string_for(row[index], '  ')
                end

            }
            puts ""
        }

        puts ""
        legend.print_color_legend()

        if (with_extreme_values)
            puts "Dataset extreme values:"
            print_extrema_information(extreme_coordinates[:maximum],
                                                 "Maximum", data_set.max_value)
            print_extrema_information(extreme_coordinates[:minimum],
                                                 "Minimum", data_set.min_value)
        end
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
            return nil
        # create output for minimum
        elsif (value == data_set.min_value)
            print legend.create_output_string_for(value,'--').white.bright
            return :minimum
        # create output for maximum
        else
            print legend.create_output_string_for(value,'++').white.bright
            return :maximum
        end
    end

    def self.print_extrema_information(coordinates, type, value)
        while (coordinates.size > 0)
                coordinate = coordinates.shift
                puts "  %s %.3f at %s." % [type, value, coordinate]
            end
    end

end
