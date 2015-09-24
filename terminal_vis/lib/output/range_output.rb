# @Author: Benjamin Held
# @Date:   2015-09-18 17:05:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-24 08:31:23

require_relative '../main/main_module'

# Output class for printing datasets of a data series within a given range
class RangeOutput

  # singleton method to print the dataset within a given range
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [DataSeries] data_series the used data series
  # @param [ParameterRepository] parameter_repository the used parameter
  #  repository
  def self.print_ranged_data(meta_data, data_series, parameter_repository)
    indices = get_and_check_indices(parameter_repository, meta_data)
    first = indices[:lower]

    while (first <= indices[:upper])
      DataOutput.print_dataset(data_series, first, meta_data,
                               parameter_repository.parameters[:extreme])
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

    indices[:lower] = Integer(TerminalVis.parameter_handler.
                               repository.parameters[:range][0]) - 1
    indices[:upper] = Integer(TerminalVis.parameter_handler.
                               repository.parameters[:range][1]) - 1

    check_range_parameters(meta_data, indices[:lower], indices[:upper])

    return indices
  end

  # method to check if the input parameters are valid
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [Integer] first the lower range value
  # @param [Integer] second the upper range value
  def self.check_range_parameters(meta_data, first, second)
    size = meta_data.domain_z.number_of_values

    first_lesser_second?(first, second)
    parameter_in_meta_range?(meta_data, first, second)
  end

  # method to check if the first parameter is lesser than the second
  # @param [Integer] first the lower range value
  # @param [Integer] second the upper range value
  # @return [boolean] true, if first < second
  # @raise [ArgumentError] if first >= second
  def self.first_lesser_second?(first, second)
    if (first >= second)
      raise ArgumentError,
        " Error: First parameter of -r greater than the second"
    end
    return true
  end

  # method to check if the parameters are within the range specified by the
  # meta data
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [Integer] first the lower range value
  # @param [Integer] second the upper range value
  # @return [boolean] true, if both parameter are within the meta data range
  # @raise [ArgumentError] if (first < 0 | second > data size)
  def self.parameter_in_meta_range?(meta_data, first, second)
    size = meta_data.domain_z.number_of_values

    if (first < 0)
      raise ArgumentError,
        " Error: First parameter of -r is lesser or equal 0"
    end

    if (second >= size)
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
