# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-01 19:17:18

require_relative '../graphics/string'
require_relative '../data/data_set'
require_relative '../data/data_series'
require_relative '../graphics/color_legend'
require_relative 'data_axis'

# Simple data output for the terminal visualization
class DataOutput

  # method to visualize the dataset at the index
  # @param [DataSeries] data_series the data series which should be visualized
  # @param [Integer] index the index of the desired data set
  # @param [MetaData] meta_data the corresponding meta data
  # @param [boolean] with_extreme_values boolean which provides the information
  #   if the extreme values of the dataset should be visualized as well
  def self.print_dataset(data_series, index, meta_data, with_extreme_values)
    set_attributes(meta_data, data_series.series[index], with_extreme_values)
    @legend = ColorLegend::ColorData.
          new(data_series.min_value, data_series.max_value)
    print_output_head(index)

    print_data
  end

  # method to visualize the difference of two datasets
  # @param [DataSet] data_set the dataset which should be visualized
  # @param [MetaData] meta_data the corresponding meta data
  # @param [Array] indices the indices of the two datasets which should be
  #   substracted
  # @param [boolean] with_extreme_values boolean which provides the information
  #   if the extreme values of the dataset should be visualized as well
  def self.print_delta(data_set, meta_data, indices, with_extreme_values)
    set_attributes(meta_data, data_set, with_extreme_values)
    @legend = ColorLegend::ColorDelta.
          new(data_set.min_value, data_set.max_value)
    puts "Printing difference for datasets #{indices[0]} and " \
       "#{indices[1]}.\n\n"
    print_data
  end

  private
  # @return [ColorLegend] the color legend for the data
  attr :legend
  # @return [boolean] if the output should highlight the extreme values
  attr :with_extreme_values
  # @return [MetaData] the currently used meta data
  attr :meta_data
  # @return [DataSet] the used dataset
  attr :data_set

  # method to set the attributes
  # @param [MetaData] meta_data the used meta data
  # @param [DataSet] data_set the used dataset
  # @param [boolean] with_extreme_values boolean to determine if extreme values
  #  should be marked
  def self.set_attributes(meta_data, data_set, with_extreme_values)
    @meta_data = meta_data
    @data_set = data_set
    @with_extreme_values = with_extreme_values
  end

  # prints the data and the additional informations
  def self.print_data
    extreme_coordinates = print_data_and_get_extrema
    DataAxis.print_x_axis_values(@meta_data)

    puts ""
    @legend.print_color_legend()

    print_extreme_information(extreme_coordinates) if (@with_extreme_values)

    print_meta_information

    puts "\n"
  end

  # reverses the data to print it in the correct occurence
  # @return [Hash] coordinate indices of the extreme values
  def self.print_data_and_get_extrema
    extreme_coordinates = {
      :maximum => Array.new(),
      :minimum => Array.new()
    }

    # reverse the data to start with the highest y-value as the first
    # output line
    reversed_data = @data_set.data.to_a.reverse.to_h

    reversed_data.each_pair { |key, row|
      DataAxis.print_y_line_beginning(@meta_data.domain_y, key)
      row.each_index { |index|
        output = determine_output_type_and_print_value(row[index])
        extreme_coordinates[output] << [index, key] if (output != :normal)
      }
      puts ""
    }

    return extreme_coordinates
  end

  # prints the meta information consisting of dataset name and informations
  # of the different dimensions
  def self.print_meta_information
    puts "\nDataset: #{@meta_data.name}"

    print_domain_information(@meta_data.domain_x, "\nX")
    print_domain_information(@meta_data.domain_y, 'Y')

    if (@meta_data.domain_z != nil)
      print_domain_information(@meta_data.domain_z, 'Z')
    end
  end

  # prints the domain information for the given domain
  # @param [DataDomain] domain the domain which information should be printed
  # @param [String] dim_string the string with the domain identifier
  def self.print_domain_information(domain, dim_string)
    puts "%s-axis with %s from %.1f up to %.1f and steprange %.1f." %
      [dim_string, domain.name, domain.lower, domain.upper, domain.step]
  end

  # creates a headline before printing the data set based on the values
  # of the z dimension
  # @param [Integer] index the number of the dataset
  def self.print_output_head(index)
    z_delta = index * @meta_data.domain_z.step
    puts "\nPrinting dataset for %.2f" %
          (@meta_data.domain_z.lower + z_delta)
    puts "\n"
  end

  # in case of extreme values this method checks, if the current value
  # is equal one of the two extreme values, if true denote the special
  # markings
  # @param [Float] value the data value which should be visualized
  # @return [Symbol] symbol to determine which kind of output was printed
  def self.determine_output_type_and_print_value(value)
    # create output for maximum
    if (value == @data_set.max_value && @with_extreme_values)
      print '++'.light_gray.bright.black_bg
      return :maximum
    # create output for minimum
    elsif (value == @data_set.min_value && @with_extreme_values)
      print '--'.light_gray.bright.black_bg
      return :minimum
    # create normal output
    else
      print @legend.create_output_string_for(value,'  ')
      return :normal
    end
  end

  # prints the coordinates and values of the extreme values
  # @param [Hash] extreme_coordinates Hash with positions of extrema
  def self.print_extreme_information(extreme_coordinates)
    puts "Dataset extreme values:"
      print_extreme_values_for(extreme_coordinates[:maximum],
                         "Maximum", @data_set.max_value)
      print_extreme_values_for(extreme_coordinates[:minimum],
                         "Minimum", @data_set.min_value)
  end

  # prints all the coordinates of the given extreme value
  # @param [Array] coordinates coordinates of the eytreme values
  # @param [String] type name of the extreme value
  # @param [Float] value the extreme value
  def self.print_extreme_values_for(coordinates, type, value)
    while (coordinates.size > 0)
        coordinate = coordinates.shift
        color = @legend.create_output_string_for(value,'  ')
        puts "  %s %.3f at %s [%s]." % [type, value, coordinate, color]
    end
  end

end
