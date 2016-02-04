# @Author: Benjamin Held
# @Date:   2015-05-30 13:34:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-04 15:27:22

# This module groups the different color legends that are used to visualize the
# output. The class {Base} provides the basic methods that are needed. Child
# classes only need to implement the method {Base#create_output_string_for}.
module ColorLegend

  require_relative '../graphics/string'

  # This class provides basic methods for the other color legends to work
  # with. The children need to define the method
  # {#create_output_string_for} which should return the
  # desired output string. If the child class does not implement this method
  # {ColorLegend::Base} raises a {NotImplementedError}.
  class Base
    # @return [Array[Float]] Array with interval values
    attr_reader :value_legend
    # @return [Float] minimum boundary
    attr_reader :min_value
    # @return [Float] maximum boundary
    attr_reader :max_value
    # @return [Float] size of intervals
    attr_reader :delta

    # initialization
    # @param [Float] min_value minimum value
    # @param [Float] max_value maximum value
    def initialize(min_value, max_value)
      @min_value = min_value
      @max_value = max_value
    end

    # prints color legend with given colors
    # @param [boolean] with_legend boolean which determines if the extended
    #  legend options should be printed
    def print_color_legend(with_legend)
      puts "Legend: %.3f; %.3f; delta = %.3f" % [@min_value, @max_value, delta]
      @value_legend.each { |value|
        2.times {print create_output_string_for(value, '  ') }
      }

      if (with_legend)
        print_interval_values
      end

      puts
    end

    # prints the intervall boundaries of the color legend if the parameter
    # -l is set
    def print_interval_values
      @value_legend.each_index { |index|
        puts if (index % 5 == 0)
        value = @value_legend[index]
        print create_output_string_for(value, " <= #{value};").
              black.exchange_grounds
      }
    end

    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def create_output_string_for(value, out_str)
      fail NotImplementedError, " Error: the subclass #{self.class} " \
        "needs to implement the method: create_output_string_for " \
        "from its base class".red
    end

    private

    # creates color legend
    # {#min_value} + i * {#delta} => value at index i + 1
    # @param [Integer] length the number of colors of the legend
    def create_color_legend(length)
      @delta = (@max_value.to_f - @min_value.to_f).abs / length

      @value_legend = Array.new(length)

      @value_legend.each_index { |index|
        @value_legend[index] = (@min_value +  (index + 1) *
                    @delta).round(3)
      }
    end

  end

end

require_relative 'color_data'
require_relative 'color_delta'
