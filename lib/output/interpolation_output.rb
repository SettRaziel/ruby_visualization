require_relative '../graphics/color_legend'
require_relative '../math/interpolation'

# Output class to vizualize results issued within the scope of interpolation
class InterpolationOutput

  # initialization
  # @param [Float] value the interpolation value
  # @param [Integer] index the indes of the used dataset
  # @param [Hash] coordinates the coordinates for the interpolation
  # @param [DataSeries] data_series the data series that contains dataset
  #   used in the interpolation
  def initialize(value, index, coordinates, data_series)
    boundary_points = TerminalVis::Interpolation::BilinearInterpolation.
                      get_boundary_points(coordinates[:x], coordinates[:y])

    print_result(value, boundary_points, data_series)

    puts "\nInterpolated value for coordinate (#{coordinates[:x]}, " \
           "#{coordinates[:y]}) of dataset #{index} with result: " \
           "#{value.round(3)}."
  end

  private
  # @return [ColorData] the color legend used for the dataset
  attr :color_legend

  # method to print the colored result of the interpolation
  # @param [Float] value the interpolated value
  # @param [Hash] boundary_points a hash containing the four used boundary
  #  points of the interpolation
  # @param [DataSeries] data_series the data series that contains dataset
  #   used in the interpolation
  def print_result(value, boundary_points, data_series)
    @color_legend = ColorLegend::ColorData.new(data_series.min_value,
                                               data_series.max_value)
    print_boundary_line(boundary_points[:d_xy1], boundary_points[:d_x1y1])
    print_interpolation_line(value)
    print_boundary_line(boundary_points[:d_xy], boundary_points[:d_x1y])
    nil
  end

  # method to print the line for two boundary points
  # @param [DataPoint] point1 the point with x_min and y = const.
  # @param [DataPoint] point2 the point with x_max and y = const.
  def print_boundary_line(point1, point2)
    print_times_blank(4)
    print "#{create_colored_substrings(point1.value)}"
    print_times_blank(10)
    puts "#{create_colored_substrings(point2.value)}"
    nil
  end

  # method to print the line with the interpolation value
  # @param [Float] value the interpolated value
  def print_interpolation_line(value)
    print_times_blank(10)
    print "#{create_colored_substrings(value)}"
    print_times_blank(8)
    puts "(#{value.round(3)})"
    nil
  end

  # method to print the required white spaces
  # @param [Integer] amount the number of required white spaces
  def print_times_blank(amount)
    amount.times { print ' '}
    nil
  end

  # method the visualize the values for the output
  # @param [Float] value a data value or an interpolation value
  # @return [String] the colored string for the given value
  def create_colored_substrings(value)
    if (value != nil)
      @color_legend.create_output_string_for(value, '  ')
    else
      print '  '
    end
  end

end
