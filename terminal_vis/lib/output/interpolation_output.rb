# @Author: Benjamin Held
# @Date:   2015-11-11 16:01:35
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-13 11:57:09

# Output class to vizualize results issued within the scope of interpolation
class InterpolationOutput

  # basic entry method to create output for interpolated values
  # @param [Float] value the interpolation value
  # @param [Integer] index the indes of the used dataset
  # @param [Hash] coordinates the coordinates for the interpolation
  def self.interpolation_output(value, index, coordinates)

    puts "Interpolated value for coordinate (#{coordinates[:x]}, " \
           "#{coordinates[:y]}) of dataset #{index} with result: " \
           "#{value.round(3)}."
  end

end
