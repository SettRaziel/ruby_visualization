# @Author: Benjamin Held
# @Date:   2016-04-26 15:23:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-05-01 12:52:27

require_relative '../math/time_line'
require_relative '../math/statistic'
require_relative 'terminal_size'

class TimelineScaling < Timeline
  # @return [MetaData] the scaled meta data based on the terminal size
  attr_reader :scaled_meta

  # initialization
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [DataSeries] data_series the data series which should be used
  # @param [Hash] parameters a hash containing the required parameter
  def initialize(meta_data, data_series, parameters)
    get_and_set_size
    check_dataset_dimension(meta_data)

    values = collect_values(meta_data, data_series,
                            parameters[:x], parameters[:y])
    values = scale_values(values, meta_data)

    determine_extrema(values) # extrema of time values

    determine_value_boundaries # ordinate values for each line

    create_output(determine_nearest_index(values))
  end

  private
  # @return [Integer] the number of fields per row of the used terminal
  attr :columns

  # method to set the available lines and columns based on the terminal size
  # @raise [RangeError] if the value of one dimension undercut the given
  #   threshold value
  def get_and_set_size
    ts = TerminalSize::TerminalSize.new()
    @lines = ts.lines - 8
    @columns = ts.columns - 10
    if (@lines < 5)
      raise RangeError, ' Error : invalid y_size of timeline (min.: 5)'.red
    end
    if (@columns < 10)
      raise RangeError, ' Error : invalid x_size of timeline (min.: 10)'.red
    end
  end

  # method to scale the calculated values if required
  # @param [Array] values the collected values d(x,y)[z]
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @return [Array] the scaled values d(x,y)[z]
  def scale_values(values, meta_data)
    if (values.length > @columns)
      scale_meta_data(meta_data)
      scale_with_mean_values(values, meta_data)
    else
      @scaled_meta = meta_data
      return values
    end
  end

  # method to generate a mapping where all available values are mapped on the
  # number of columns specified by the terminal size
  # @param [Array] values the collected values d(x,y)[z]
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @return [Array] the scaled values d(x,y)[z]
  def scale_with_mean_values(values, meta_data)
    scaled_values = Array.new()
    delta_x = ((meta_data.domain_z.number_of_values) /
               Float(@columns)).round(5)
    index_old = 0
    index_new = delta_x

    while (index_new.round < values.length)
      if (index_new.round - index_old > 1)
        scaled_values << calculate_mean_value(index_old, index_new, values)
      else
        scaled_values << values[index_old]
      end
      index_old = Integer(index_new.round)
      index_new += delta_x
    end
    scaled_values << values[index_old]

    return scaled_values
  end

  # method to calculate the mean value for the values between the indices
  # @param [Integer] index_old the lower index representing the last unused
  #    value
  # @param [Float] index_new the current value based on the calculated delta
  # @param [Array] values the collected values d(x,y)[z]
  # @return [Float] the mean value of the values from index_old to index_new
  def calculate_mean_value(index_old, index_new, values)
    temp = index_old
    means = Array.new()
    while (temp < index_new.round)
      means << values[temp]
      temp += 1
    end
    Statistic.mean_value(means)
  end

  # method to adjust the meta data and replace the z-dimension
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [MetaData] the scaled meta data
  def scale_meta_data(meta_data)
    delta_z = ((meta_data.domain_z.number_of_values) /
               Float(@columns)).round(5)
    meta_string = [meta_data.name]
    meta_string.concat(add_domain_information(meta_data.domain_x,
                                              meta_data.domain_x.step))
    meta_string.concat(add_domain_information(meta_data.domain_y,
                                              meta_data.domain_y.step))
    meta_string.concat(add_domain_information(meta_data.domain_z, delta_z))
    # return the new meta data object
    @scaled_meta = MetaData::MetaData.new(meta_string)
  end

  # method to add the required parameter to the meta data string
  # @param [DataDomain] data_domain the required {DataDomain}
  # @param [Float] new_step the new delta between two data values for the given
  #    data dimension
  # @return [Array] an array containing the string values for the given domain
  def add_domain_information(data_domain, new_step)
    [data_domain.name, data_domain.lower, data_domain.upper, new_step]
  end

end
