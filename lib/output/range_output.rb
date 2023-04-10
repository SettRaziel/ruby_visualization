require_relative "../data/meta_data"
require_relative "../data/data_series"

# Output class for printing datasets of a data series within a given range
class RangeOutput

  # singleton method to print the dataset within a given range
  # @param [VisMetaData] meta_data the metadata of the used data series
  # @param [DataSeries] data_series the used data series
  # @param [Hash] parameters the required parameter
  # @param [Hash] options hash with the boolean values for extreme values and
  #   extended legend output
  def initialize(meta_data, data_series, parameters, options)
    check_range_parameters(meta_data, parameters)
    options[:index] = parameters[:lower]

    while (options[:index] <= parameters[:upper])
      determine_output_resolution(data_series, meta_data, options)
      determine_animation(parameters)
      options[:index] += 1
    end
  end

  private

  # method to check if the input parameters are valid
  # @param [VisMetaData] meta_data the metadata of the used data series
  # @param [Hash] indices a hash containing the indices :first and :second
  # @return [boolean] true, if the parameters are in the range of the meta data
  def check_range_parameters(meta_data, indices)
    first_lesser_second?(indices)

    parameter_in_meta_range?(meta_data, indices)
  end

  # method to check if the first parameter is lesser than the second
  # @param [Hash] indices a hash containing the indices :first and :second
  # @return [boolean] true, if first < second
  # @raise [ArgumentError] if first >= second
  def first_lesser_second?(indices)
    if (indices[:lower] >= indices[:upper])
      raise ArgumentError, " Error: First parameter of -r is equal or greater than the second".red
    end
    return true
  end

  # method to check if the parameters are within the range specified by the
  # {MetaData::VisMetaData}
  # @param [VisMetaData] meta_data the metadata of the used data series
  # @param [Hash] indices a hash containing the indices :first and :second
  # @return [boolean] true, if both parameter are within the meta data range
  # @raise [ArgumentError] if (first < 0 | second > data size)
  def parameter_in_meta_range?(meta_data, indices)
    size = meta_data.domain_z.number_of_values

    if (indices[:lower] < 0)
      raise ArgumentError, " Error: First parameter of -r is lesser or equal 0".red
    end

    if (indices[:upper] >= size)
      raise ArgumentError, " Error: Second parameter of -r greater than size of data series".red
    end

    return true
  end

  # method to determine which type of output should be used
  # @param [DataSeries] data_series the used data series
  # @param [VisMetaData] meta_data the metadata of the used data series
  # @param [Hash] options hash with the boolean values for extreme values and
  def determine_output_resolution(data_series, meta_data, options)
    if (!options[:auto_scale])
      DataOutput::SingleOutput.new(data_series, meta_data, options)
    else
      DataOutput::ScaledDatasetOutput.new(data_series, meta_data, options)
    end
  end

  # method to determine the art of visualization. Without -all or animation
  # speed = 0 the progress will be manual, speed > 0 determines speed in seconds
  # @param [Hash] parameters the required parameters parameter
  def determine_animation(parameters)
    animation_speed = 0
    if (parameters[:all])
      animation_speed = Integer(parameters[:all])
    end

    if (animation_speed > 0)
      sleep(animation_speed)
    else
      print "press Enter to continue ...".green
      # STDIN to read from console when providing parameters in ARGV
      STDIN.gets.chomp
    end
  end

end
