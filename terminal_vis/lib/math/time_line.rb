# @Author: Benjamin Held
# @Date:   2015-08-24 10:28:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-26 13:10:28

require_relative 'interpolation'

# This class collects all data values of the z dimension of a {DataSeries} for
# a given pair of coordinates (x,y). For a given resolution {#size} the values
# are assigned to the nearest value of {#value_boundaries} to be drawn in a
# terminal or window.
class Timeline

  # public singleton method to start the creation of a timeline
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [DataSeries] data_series the data series which should be used
  # @param [Float] x x-coordinate of the regarded point
  # @param [Float] y y-coordinate of the regarded point
  def self.create_timeline(meta_data, data_series, x, y)
    values = collect_values(meta_data, data_series, x, y) # time_values

    extrema = determine_extrema(values) # extrema of time values

    determine_value_boundaries(extrema) # ordinate values for each line

    return create_output(determine_nearest_index(values))
  end

  private
  # @return [Array] the values for each output line
  attr :value_bondaries
  # @return [Integer] resolution of the value scale
  @size = 20

  # this method collects all data values d(x,y) in z
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [DataSeries] data_series the data series which should be used
  # @param [Float] x x-coordinate of the regarded point
  # @param [Float] y y-coordinate of the regarded point
  # @return [Array] the collected values d(x,y)[z]
  def self.collect_values(meta_data, data_series, x, y)
    values = Array.new()

    data_series.series.each { |data_set|
      values << TerminalVis::Interpolation::BilinearInterpolation.
                               bilinear_interpolation(meta_data,data_set, x, y)
    }

    return values
  end

  # this method determines the extreme values of the collected data d(x,y)[z]
  # @param [Array] the collected values d(x,y)[z]
  # @return [Hash] the maximum and minimum values of the collected data
  def self.determine_extrema(values)
    extrema = {
      :maximum => values[0],
      :minimum => values[0]
    }

    values.each { |value|
      extrema[:maximum] = value if (value > extrema[:maximum])
      extrema[:minimum] = value if (value < extrema[:minimum])
    }

    return extrema
  end

  # this method determines the value boundaries based on the resolution {#size}
  # @param [Hash] the maximum and minimum values of the collected data
  def self.determine_value_boundaries(extrema)
    delta = (extrema[:maximum] - extrema[:minimum]).abs
    upper_boundary = extrema[:maximum] + delta / 10.0
    lower_boundary = extrema[:minimum] - delta / 10.0

    delta = (upper_boundary - lower_boundary).abs / @size
    @value_bondaries = [lower_boundary.round(5)]
    while (lower_boundary.round(5) < upper_boundary.round(5))
      lower_boundary += delta
      @value_bondaries << lower_boundary.round(5)
    end
  end

  # this method calculates for every collected value the index of the interval
  # values {#value_boundaries} with the least distance
  # @param [Array] the collected values d(x,y)[z]
  # @return [Hash] mapping of value => index
  def self.determine_nearest_index(values)
    mapped_values = Hash.new()

    values.each { |value|
      mapped_values[value] = get_nearest_index(value)
    }

    return mapped_values
  end

  # helper methode to calculate the nearest index for the collected data values
  # @param [Float] value data value
  # @return [Integer] the nearest index
  def self.get_nearest_index(value)
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
  # @param [Hash] mapping of value => index
  # @return [Hash] the occurence of a boundary value in the z dimension as the
  #  result of being the nearest index for a collected value at position z
  def self.create_output(mapped_values)
    output = Hash.new(@size)

    @value_bondaries.each_index { |index|
      line = Array.new()
      mapped_values.values.each { |value|
        if (value == index)
          line << 1
        else
          line << 0
        end
      }
      output[@value_bondaries[index]] = line
    }

    return output
  end

end
