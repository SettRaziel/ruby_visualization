# @Author: Benjamin Held
# @Date:   2015-09-11 11:16:06
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-11 11:55:35

module MetaData

  # DataDomain represents the meta data for one dimension
  # @raise [ArgumentError] if parsing of attribute values fails
  class DataDomain
    # @return [String] name of the data
    attr_reader :name
    # @return [Float] lower boundary of the dimension
    attr_reader :lower
    # @return [Float] upper boundary of the dimension
    attr_reader :upper
    # @return [Float] step range between two values
    attr_reader :step

    # initialization
    # @param [String] name the name of the data
    # @param [String] lower the lower boundary of the dimension
    # @param [String] upper the upper boundary of the dimension
    # @param [String] step the step range between two values
    # @raise [ArgumentError] when one of the parameters is not a number
    def initialize(name, lower, upper, step)
      @name = name
      begin
        @lower = Float(lower)
        @upper = Float(upper)
        @step = Float(step)
      rescue ArgumentError => e
        raise ArgumentError, "Error in data domain: non number argument."
      end
    end

    # method to get the number of data values specified by the values of the
    # domain object
    # @return [Integer] the number of data values
    def number_of_values
      Integer((@upper - @lower) / @step) + 1
    end

    # method to get the coordinate to a given index
    # @param [Integer] index the given index
    # @return [Float] the coordinate
    # @raise [RangeError] if the index creates a coordinate that lies out of
    #  the domain range
    def get_coordinate_to_index(index)
      coordinate = lower + index * step
      if (coordinate < lower || coordinate > upper)
        raise RangeError,
        " Error: #{index} creates a coordinate that lies out of range"
      end
      return coordinate
    end

  end

end
