# @Author: Benjamin Held
# @Date:   2015-09-18 17:05:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-20 16:59:39

require_relative '../main/main_module'

# Output class for printing datasets of a data series within a given range
class RangeOutput

  # singleton method to print the dataset within a given range
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [DataSeries] data_series the used data series
  # @param [ParameterRepository] parameter_repository the used parameter
  #   repository
  # @param [Hash] options hash with the boolean values for extreme values and
  #   extended legend output
  def self.print_ranged_data(meta_data, data_series, parameter_repository,
                             options)
    indices = get_and_check_indices(parameter_repository, meta_data)
    first = indices[:lower]

    while (first <= indices[:upper])
      DataOutput.print_dataset(data_series, first, meta_data, options)
      determine_animation(parameter_repository)
      first += 1
    end
  end

  private

  # method to read and check the indices for the range parameter
  # @param [ParameterRepository] parameter_repository the used parameter
  #  repository
  # @param [MetaData] meta_data the metadata of the used data series
  # @return [Hash] a hash containing the two indices
  def self.get_and_check_indices(parameter_repository, meta_data)
    indices = Hash.new()

    indices[:lower] = Integer(parameter_repository.parameters[:range][0]) - 1
    indices[:upper] = Integer(parameter_repository.parameters[:range][1]) - 1

    check_range_parameters(meta_data, indices)

    return indices
  end

  # method to check if the input parameters are valid
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [Hash] indices a hash containing the indices :first and :second
  # @return [boolean] true, if the parameters are in the range of the meta data
  def self.check_range_parameters(meta_data, indices)
    size = meta_data.domain_z.number_of_values

    first_lesser_second?(indices)
    parameter_in_meta_range?(meta_data, indices)
  end

  # method to check if the first parameter is lesser than the second
  # @param [Hash] indices a hash containing the indices :first and :second
  # @return [boolean] true, if first < second
  # @raise [ArgumentError] if first >= second
  def self.first_lesser_second?(indices)
    if (indices[:lower] >= indices[:upper])
      raise ArgumentError,
        " Error: First parameter of -r greater than the second"
    end
    return true
  end

  # method to check if the parameters are within the range specified by the
  # meta data
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [Hash] indices a hash containing the indices :first and :second
  # @return [boolean] true, if both parameter are within the meta data range
  # @raise [ArgumentError] if (first < 0 | second > data size)
  def self.parameter_in_meta_range?(meta_data, indices)
    size = meta_data.domain_z.number_of_values

    if (indices[:lower] < 0)
      raise ArgumentError,
        " Error: First parameter of -r is lesser or equal 0"
    end

    if (indices[:upper] >= size)
      raise ArgumentError,
        " Error: Second parameter of -r greater than size of data series"
    end

    return true
  end

  # method to determine the art of visualization. Without -all or animation
  # speed = 0 the progress will be manual, speed > 0 determines speed in seconds
  # @param [ParameterRepository] parameter_repository the used parameter
  #  repository
  def self.determine_animation(parameter_repository)
    animation_speed = 0
    if (parameter_repository.parameters[:all])
      animation_speed = Integer(parameter_repository.parameters[:all])
    end

    if (animation_speed > 0)
      sleep(animation_speed)
    else
      print 'press Enter to continue ...'
      # STDIN to read from console when providing parameters in ARGV
      STDIN.gets.chomp
    end
  end

end
