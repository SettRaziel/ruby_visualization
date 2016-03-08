# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-08 14:33:11

require_relative '../data/data_set'
require_relative '../data/data_series'
require_relative '../data/meta_data'
require_relative '../graphics/color_legend'
require_relative '../graphics/string'
require_relative 'data_axis'

# This module groups the different output formats that are used to visualize the
# output. The class {Base} provides the basic methods that are needed.
module DataOutput

  # This class provides basic methods for the other color legends to work
  # with. The children need to define the method
  # {DataOutput::Base.print_meta_information} which will print the desired meta information for
  # the chosen output. If the child class does not implement this method
  # {DataOutput::Base} raises a {NotImplementedError}.
  class Base
    private
    # @return [ColorLegend] the color legend for the data
    attr :legend
    # @return [boolean] if the output should highlight the extreme values
    attr :with_extreme_values
    # @return [DataSet] the used dataset
    attr :data_set

    # method to set the attributes
    # @param [DataSet] data_set the used dataset
    # @param [boolean] with_extreme_values boolean to determine if extreme
    #  values should be marked
    def self.set_attributes(data_set, with_extreme_values)
      @data_set = data_set
      @with_extreme_values = with_extreme_values
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
      puts 'Dataset extreme values:'
        print_extreme_values_for(extreme_coordinates[:maximum],
                           'Maximum (++):', @data_set.max_value)
        print_extreme_values_for(extreme_coordinates[:minimum],
                           'Minimum (--):', @data_set.min_value)
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

    # prints the data and the additional informations
    # @param [boolean] with_legend boolean which determines if the extended
    #  legend options should be printed
    def self.print_data(with_legend, domain_x, domain_y)
      extreme_coordinates = print_data_and_get_extrema(domain_y)
      DataAxis.print_x_axis_values(domain_x, domain_y)

      puts
      @legend.print_color_legend(with_legend)

      print_extreme_information(extreme_coordinates) if (@with_extreme_values)

      print_meta_information

      puts "\n"
    end

    # reverses the data to print it in the correct occurence
    # @return [Hash] coordinate indices of the extreme values
    def self.print_data_and_get_extrema(domain_y)
      extreme_coordinates = {
        :maximum => Array.new(),
        :minimum => Array.new()
      }

      # reverse the data to start with the highest y-value as the first
      # output line
      reversed_data = @data_set.data.to_a.reverse.to_h

      reversed_data.each_pair { |key, row|
        DataAxis.print_y_line_beginning(domain_y, key)
        row.each_index { |index|
          output = determine_output_type_and_print_value(row[index])
          extreme_coordinates[output] << [index, key] if (output != :normal)
        }
        puts
      }

      return extreme_coordinates
    end

    # prints the domain information for the given domain
    # @param [DataDomain] domain the domain which information should be printed
    # @param [String] dim_string the string with the domain identifier
    def self.print_domain_information(domain, dim_string)
      puts "%s-axis with %s from %.1f up to %.1f and steprange %.2f." %
        [dim_string, domain.name, domain.lower, domain.upper, domain.step]
    end

    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def self.print_meta_information
      fail NotImplementedError, " Error: the subclass #{self.class} needs " \
           "to implement the method: print_meta_information " \
           "from its base class".red
    end

  end

end

require_relative 'dataset_output'
require_relative 'delta_output'
require_relative 'region_output'
require_relative 'scaled_output'
