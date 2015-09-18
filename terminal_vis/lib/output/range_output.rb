# @Author: Benjamin Held
# @Date:   2015-09-18 17:05:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-18 17:43:51

require_relative '../main/main_module'

class RangeOutput

  # singleton method to print the dataset within a given range
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [DataSeries] data_series the used data series
  # @param [ParameterRepository] parameter_repository the used parameter
  #  repository
  def self.print_ranged_data(meta_data, data_series, parameter_repository)
    first = Integer(TerminalVis.parameter_handler.
                                repository.parameters[:range][0]) - 1
    second = Integer(TerminalVis.parameter_handler.
                                 repository.parameters[:range][1]) - 1

    check_range_parameters(meta_data, first, second)

    while (first <= second)
      DataOutput.print_dataset(data_series, first, meta_data,
                               parameter_repository.parameters[:extreme])
      print 'press Enter to continue ...'
            # STDIN to read from console when providing parameters in ARGV
            STDIN.gets.chomp
      first += 1
    end
  end

  private

  # method to check if the input parameters are valid
  # @param [MetaData] meta_data the metadata of the used data series
  # @param [Integer] first the lower range value
  # @param [Integer] second the upper range value
  def self.check_range_parameters(meta_data, first, second)
    size = meta_data.domain_z.number_of_values

    first_lesser_second?(first, second)
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
  # @raise [ArgumentError] if first < 0 | second > data size
  def self.parameter_in_meta_range?(meta_data, first, second)
    size = meta_data.domain_z.number_of_values

    if (first < 0)
      raise ArgumentError,
        " Error: First parameter of -r lesser than 0"
    end

    if (second > size)
      raise ArgumentError,
        " Error: Second parameter of -r greater than size of data series"
    end

    return true
  end

end
