# @Author: Benjamin Held
# @Date:   2015-06-09 12:49:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-03 09:58:33

# MetaData stores meta information about the data series. The meta information
# can be used for two or three dimensional data series.
#   two dimensional data serie
#   <data_name>,
#   <axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,
#   <axis_description_y>,<lower_boundary_y>,<upper_boundary_y>
#
#   three dimensional data serie
#   <data_name>,
#   <axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,
#   <axis_description_y>,<lower_boundary_y>,<upper_boundary_y>,
#   <axis_description_z>,<lower_boundary_z>,<upper_boundary_z>
# @raise [IndexError] when parameter metadata has not the correct size
class MetaData
  # @return [String] the name of the data
  attr_reader :name
  # @return [DataDomain] informations of the x-dimension
  attr_reader :domain_x
  # @return [DataDomain] informations of the y-dimension
  attr_reader :domain_y
  # @return [DataDomain] informations of the y-dimension
  attr_reader :domain_z

  # initialization
  # @param [Array] metadata the array with the meta information
  # @raise [IndexError] when parameter metadata has not the correct size
  def initialize(metadata)

    if !(metadata.length == 13 || metadata.length == 9)
      raise IndexError, "Error in meta data: incorrect number of" \
                " arguments: #{metadata.length}."
    end

    @name = metadata[0]
    @domain_x = DataDomain.new(metadata[1], metadata[2], \
                   metadata[3], metadata[4])
    @domain_y = DataDomain.new(metadata[5], metadata[6], \
                   metadata[7], metadata[8])

    if (metadata.length == 13)
      @domain_z = DataDomain.new(metadata[9], metadata[10], \
                     metadata[11], metadata[12])
    else
      @domain_z = nil
    end
  end
end

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

end
