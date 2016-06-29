# @Author: Benjamin Held
# @Date:   2015-08-24 10:28:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-06-29 17:49:47

require_relative 'interpolation'

# This class collects all data values of the z dimension of a {DataSeries} for
# a given pair of coordinates (x,y). For a given resolution size the values
# are assigned to the nearest value of value_boundaries to be drawn in a
# terminal or window.
class Timeline
  # @return [Hash] the occurence of a boundary value in the z dimension as the
  #  result of being the nearest index for a collected value at position z
  attr_reader :mapped_values

  # initialization
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [DataSeries] data_series the data series which should be used
  # @param [Hash] parameters a hash containing the required parameter
  def initialize(meta_data, data_series, parameters)
    check_and_set_ysize(parameters[:y_size])
    check_dataset_dimension(meta_data)

    values = collect_values(meta_data, data_series,
                            parameters[:x], parameters[:y])

    determine_extrema(values) # extrema of time values

    determine_value_boundaries # ordinate values for each line

    create_output(determine_nearest_index(values))
  end

  private
  # @return [Array] the values for each output line
  attr :value_bondaries
  # @return [Hash] the extreme values of the timeline
  attr :extrema
  # @return [Integer] resolution of the value scale
  attr :lines

  # method to check and set the number of values for the y-dimension
  # constraint: at least 5 values in y
  # @param [Fixnum] y_size number of values in y
  # @raise [RangeError] if the number of y values is less than 5
  def check_and_set_ysize(y_size)
    if (y_size < 5)
      raise RangeError, ' Error : invalid y_value of timeline (min.: 5)'.red
    end
    @lines = y_size
  end

  # method to check for correct dataset dimensions
  # @param [MetaData] meta_data the required meta data
  # @raise [RangeError] if one of the datasets has an incorrect dimension
  def check_dataset_dimension(meta_data)
    if (!TerminalVis.data_repo.dataset_dimension_correct?(meta_data))
      raise RangeError,
            ' Error: dimension of at least one dataset is incorrect'.red
    end
  end

  # this method collects all data values d(x,y) in z
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [DataSeries] data_series the data series which should be used
  # @param [Float] x x-coordinate of the regarded point
  # @param [Float] y y-coordinate of the regarded point
  # @return [Array] the collected values d(x,y)[z]
  def collect_values(meta_data, data_series, x, y)
    values = Array.new()

    data_series.series.each { |data_set|
      values << TerminalVis::Interpolation::BilinearInterpolation.
                               bilinear_interpolation(meta_data,data_set, x, y)
    }

    return values
  end

  # this method determines the extreme values of the collected data d(x,y)[z]
  # @param [Array] values the collected values d(x,y)[z]
  def determine_extrema(values)
    @extrema = {
      :maximum => values[0],
      :minimum => values[0]
    }

    values.each { |value|
      @extrema[:maximum] = value if (value > @extrema[:maximum])
      @extrema[:minimum] = value if (value < @extrema[:minimum])
    }
  end

  # this method determines the value boundaries based on the vertical number
  # of lines
  def determine_value_boundaries
    delta = (@extrema[:maximum] - @extrema[:minimum]).abs
    upper_boundary = @extrema[:maximum] + delta / 20.0 # 5 % variance
    lower_boundary = @extrema[:minimum] - delta / 20.0 # 5 % variance

    delta = (upper_boundary - lower_boundary).abs / @lines
    @value_bondaries = [lower_boundary.round(5)]
    while (lower_boundary.round(5) < upper_boundary.round(5))
      lower_boundary += delta
      @value_bondaries << lower_boundary.round(5)
    end
  end

  # this method calculates for every collected value the index of the interval
  # values @value_boundaries with the least distance
  # @param [Array] values the collected values d(x,y)[z]
  # @return [Hash] mapping of (value => index)
  def determine_nearest_index(values)
    mapped_values = Hash.new()

    values.each { |value|
      mapped_values[value] = [get_nearest_index(value), check_extrema(value)]
    }

    return mapped_values
  end

  # helper methode to calculate the nearest index for the collected data values
  # @param [Float] value data value
  # @return [Integer] the nearest index
  def get_nearest_index(value)
    delta = value
    nearest_index = 0

    @value_bondaries.each_index { |index|
      tmp_delta = (@value_bondaries[index] - value).abs
      if (tmp_delta < delta)
        delta = tmp_delta
        nearest_index = index
      end
    }

    return nearest_index
  end

  # this method creates the basic output which can be visualized.
  # @param [Hash] mapped_values mapping of (value => index)
  def create_output(mapped_values)
    output = Hash.new(@lines)

    @value_bondaries.each_index { |index|
      line = Array.new()
      mapped_values.values.each { |value|
        if (value[0] == index)
          line << value[1]
        else
          line << [:miss]
        end
      }
      output[@value_bondaries[index]] = line
    }

    @mapped_values = output
  end

  # method to determine if the value is an extreme value and return the value
  # if it is an extreme value
  # @param [Float] value the considered value
  # @return [Array] an array containing Symbol and the value if it is an
  #  extreme value
  def check_extrema(value)
    return [:minimum, value] if (value == @extrema[:minimum])
    return [:maximum, value] if (value == @extrema[:maximum])
    return [:hit]
  end

end
