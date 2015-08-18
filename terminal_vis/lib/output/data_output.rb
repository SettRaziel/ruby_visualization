# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-17 11:27:10

require_relative '../graphics/string'
require_relative '../data/data_set'
require_relative '../data/data_series'
require_relative '../graphics/color_legend'

# Simple data output for the terminal visualization
class DataOutput

    # method to visualize the dataset at the index
    def self.print_dataset(data_series, index, meta_data, with_extreme_values)
        data_set = data_series.series[index]
        legend = ColorLegend.new(data_series.min_value, data_series.max_value)
        print_output_head(index, meta_data)

        print_data(data_set, legend, meta_data, with_extreme_values)

    end

    # method to visualize the difference of two datasets
    def self.print_delta(data_set, meta_data, indices, with_extreme_values)
        legend = ColorLegend.new(data_set.min_value, data_set.max_value)
        puts "Printing difference for datasets #{indices[0]} and " \
             "#{indices[1]}.\n\n"
        print_data(data_set, legend, meta_data, with_extreme_values)
    end

    private

    # reverses the data to print it in the correct occurence
    def self.print_data(data_set, legend, meta_data, with_extreme_values)
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
                    if (output != :normal)
                    extreme_coordinates[output] << [index, key]
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
            print_extreme_information(extreme_coordinates, data_set)
        end
        print_meta_information(meta_data)

        puts "\n"
    end

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

    # in case of extreme values this method checks, if the current value
    # is equal one of the two extreme values, if true denote the special
    # markings
    def self.create_output_with_extremes(data_set, value, legend)
        # create normal output
        if (value > data_set.min_value && value < data_set.max_value)
            print legend.create_output_string_for(value,'  ')
            return :normal
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

    # prints the coordinates and values of the extreme values
    def self.print_extreme_information(extreme_coordinates, data_set)
        puts "Dataset extreme values:"
            print_extreme_values_for(extreme_coordinates[:maximum],
                                                 "Maximum", data_set.max_value)
            print_extreme_values_for(extreme_coordinates[:minimum],
                                                 "Minimum", data_set.min_value)
    end

    # prints all the coordinates of the given extreme value
    def self.print_extreme_values_for(coordinates, type, value)
        while (coordinates.size > 0)
                coordinate = coordinates.shift
                puts "  %s %.3f at %s." % [type, value, coordinate]
            end
    end


end
