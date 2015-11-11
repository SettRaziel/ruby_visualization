# @Author: Benjamin Held
# @Date:   2015-11-11 16:01:35
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-11 16:21:32

# Output class to vizualize results issued within the scope of interpolation
class InterpolationOutput

  # basic entry method to create output for interpolated values
  # @param [Float] value the interpolation value
  # @param [Integer] index the indes of the used dataset
  # @param [ParameterRepository] parameter_repository the required parameter
  #  repository
  def self.interpolation_output(value, index, parameter_repository)

    x_coordinate = Float(parameter_repository.parameters[:coord][0])
    y_coordinate = Float(parameter_repository.parameters[:coord][1])

    puts "Interpolated value for coordinate (#{x_coordinate}, " \
           "#{y_coordinate}) of dataset #{index} with result: " \
           "#{value.round(3)}."
  end

end
