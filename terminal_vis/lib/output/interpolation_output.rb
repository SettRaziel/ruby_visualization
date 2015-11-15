# @Author: Benjamin Held
# @Date:   2015-11-11 16:01:35
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-15 12:32:52

require_relative '../graphics/color_legend'
require_relative '../math/interpolation'

# Output class to vizualize results issued within the scope of interpolation
class InterpolationOutput

  # basic entry method to create output for interpolated values
  # @param [Float] value the interpolation value
  # @param [Integer] index the indes of the used dataset
  # @param [Hash] coordinates the coordinates for the interpolation
  # @param [DataSet] data_set the used dataset
  def self.interpolation_output(value, index, coordinates, data_set)

    boundary_points = TerminalVis::Interpolation::BilinearInterpolation.
                      get_boundary_points(coordinates[:x], coordinates[:y])

    print_result(value, boundary_points, data_set)

    puts "\nInterpolated value for coordinate (#{coordinates[:x]}, " \
           "#{coordinates[:y]}) of dataset #{index} with result: " \
           "#{value.round(3)}."
  end

  private
  attr :color_legend

  def self.print_result(value, boundary_points, data_set)
    @color_legend = ColorLegend::ColorData.new(data_set.min_value,
                                              data_set.max_value)
    print_boundary_line(boundary_points[:d_xy], boundary_points[:d_x1y])
    print_interpolation_line(value)
    print_boundary_line(boundary_points[:d_xy], boundary_points[:d_x1y])
  end

  def self.print_boundary_line(point1, point2)
    print_times_blank(4)
    print "#{create_colored_substrings(point1.value)}"
    print_times_blank(10)
    puts "#{create_colored_substrings(point2.value)}"
  end

  def self.print_interpolation_line(value)
    print_times_blank(10)
    print "#{create_colored_substrings(value)}"
    print_times_blank(8)
    puts "(#{value.round(3)})"
  end

  def self.print_times_blank(amount)
    amount.times { print ' '}
  end

  def self.create_colored_substrings(value)
    @color_legend.create_output_string_for(value, '  ')
  end

end
