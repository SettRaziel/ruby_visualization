# @Author: Benjamin Held
# @Date:   2016-03-10 11:45:32
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-06-26 18:24:05

require_relative '../data/meta_data'
require_relative 'terminal_size'

# Helper class to generate a scaled {DataSet} from a {MetaData::MetaData}
# => {DataSet}
# pair with the scaling based on the size of the terminal where the script is
# started.
class DatasetScaling
  # @return [MetaData] the {MetaData} of the scaled {DataSet}
  attr_reader :scaled_meta
  # @return [DataSet] the scaled {DataSet}
  attr_reader :scaled_data_set

  # initialization
  # @param [MetaData] meta_data the {MetaData::MetaData} of the {DataSet} that
  #   should be scaled
  # @param [DataSet] data_set the data set which should be visualized
  def initialize(meta_data, data_set)
    @meta_data = meta_data
    ts = TerminalSize::TerminalSize.new()
    @lines = ts.lines - 14
    @columns = ts.columns - 10
    check_value_boundaries
    calculate_new_resolution_meta
    @scaled_data_set = calculate_scaled_dataset(data_set)
  end

  private
  # @return [MetaData] the original {MetaData::MetaData} of the {DataSet}
  attr :meta_data
  # @return [Integer] the number of lines of the used terminal
  attr :lines
  # @return [Integer] the number of fields per row of the used terminal
  attr :columns

  # method to create the scaled dataset by interpolating new data values
  # @param [DataSet] data_set the data set which should be visualized
  # @return [Dataset] the scaled dataset
  def calculate_scaled_dataset(data_set)
    coordinates = determine_coordinates
    values = determine_values

    TerminalVis::Interpolation.region_interpolation(@meta_data, data_set,
                                                    coordinates, values)
  end

  # method to create the meta data object for the scaled dataset
  def calculate_new_resolution_meta
    # determine new meta information and create ne meta object
    meta_string = [@meta_data.name]
    meta_string.concat(create_new_data_dimensions)
    meta_string.concat(add_domain_information(@meta_data.domain_z,
                                              @meta_data.domain_z.step))
    # return the new meta data object
    @scaled_meta = MetaData::MetaData.new(meta_string)
  end

  # method to check if the dimensions of the terminal are big enough to
  # create a useful result
  def check_value_boundaries
    if (@lines < 9 || @columns < 20)
      raise ArgumentError,
            ' Error: The terminal size is to small for scaled output'.red
    end
  end

  # method to create the entris for the x and y domain of the scaled meta data
  # @return [Array] the meta informations for the x and y domain
  def create_new_data_dimensions
    # map the meta information to the resolution
    delta_x = ((@meta_data.domain_x.upper - @meta_data.domain_x.lower) /
               @columns).round(3) * 2
    delta_y = ((@meta_data.domain_y.upper - @meta_data.domain_y.lower) /
               @lines).round(3)
    meta_string = add_domain_information(@meta_data.domain_x, delta_x)
    meta_string.concat(add_domain_information(@meta_data.domain_y, delta_y))
  end

  # method to add the required parameter to the {MetaData::MetaData} string
  # @param [MetaData::DataDomain] data_domain the required
  #    {MetaData::DataDomain}
  # @param [Float] new_step the new delta between two data values for the given
  #    data dimension
  # @return [Array] an array containing the string values for the given domain
  def add_domain_information(data_domain, new_step)
    [data_domain.name, data_domain.lower, data_domain.upper, new_step]
  end


  # method to retrieve the central coordinate of the dataset
  # @return [Hash] a hash with the x and y coordinate
  def determine_coordinates
    coordinates = Hash.new()
    coordinates[:x] = @scaled_meta.domain_x.lower +
                      calculated_dimension_delta(@scaled_meta.domain_x)
    coordinates[:y] = @scaled_meta.domain_y.lower +
                      calculated_dimension_delta(@scaled_meta.domain_y)
    return coordinates
  end

  # method to calculate the required parameter values for the interpolation
  # @return [Hash] a hash with the required parameters
  def determine_values
    { :inter_x => calculated_dimension_delta(@scaled_meta.domain_x),
      :delta_x => @scaled_meta.domain_x.step,
      :inter_y => calculated_dimension_delta(@scaled_meta.domain_y),
      :delta_y => @scaled_meta.domain_y.step }
  end

  # method to calculate the half distance of a data domain
  # @param [MetaData::DataDomain] data_domain the required
  #    {MetaData::DataDomain}
  # @return [Float] the middle distance of the given data domain
  def calculated_dimension_delta(data_domain)
    ((data_domain.upper - data_domain.lower) / 2).round(3)
  end

end
