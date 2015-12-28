# @Author: Benjamin Held
# @Date:   2015-12-13 16:50:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-28 08:56:05

require_relative '../data/data_set'
require_relative '../data/data_domain'
require_relative '../graphics/color_legend'

# Output class to visualize the interpolation of a region
class RegionOutput

  # singleton method to generate the output for the given region
  # @param [DataSet] data the data that should be visualized
  # @param [Hash] coordinates a hash containing the x and y coordinate of the
  #   central point of the region
  # @param [Hash] values a hash containing all required values to interpolate
  #   the region
  def self.region_output(data, coordinates, values)
    domain_x = create_data_domain("x", coordinates[:x], values[:inter],
                                                        values[:delta])
    domain_y = create_data_domain("y", coordinates[:y], values[:inter],
                                                        values[:delta])

    print_output_head(coordinates, values)
    print_data(data, domain_x, domain_y)
  end

  private

  # method to create the special data domains for the x- and y-dimension
  # @param [String] label the name of the domain
  # @param [Float] coordinates the coordinate of the region center in the
  #   required dimension
  # @param [Float] interval the value to specify the value set in the
  #   considered dimension
  # @param [Float] delta the steprange in the considered dimension
  # @return [DataDomain] the domain object based on the input parameter
  def self.create_data_domain(label, coordinate, interval, delta)
    lower = (coordinate - interval).round(3)
    upper = (coordinate + interval + delta).round(3)

    MetaData::DataDomain.new(label, lower, upper, delta)
  end

  # method to print the data with values and axis
  # @param [DataSet] data the data that should be visualized
  # @param [DataDomain] domain_x the data domain describing the x-dimension
  # @param [DataDomain] domain_y the data domain describing the y-dimension
  def self.print_data(data, domain_x, domain_y)
    legend = ColorLegend::ColorData.new(data.min_value, data.max_value)

    reversed_data = data.data.to_a.reverse.to_h

    reversed_data.each_pair { |key, row|
      DataAxis.print_y_line_beginning(domain_y, key)
      row.each_index { |index|
        print legend.create_output_string_for(row[index],'  ')
      }
      puts
    }
    DataAxis.print_x_axis_values(domain_x, domain_y)
    puts

    legend.print_color_legend(false)
  end

  # method to print the output head
  # @param [Hash] coordinates a hash containing the coordinates of the origin
  # @param [Hash] values a hash containing the required values
  def self.print_output_head(coordinates, values)
    puts "Printing interpolated region around (%.2f, %.2f) for data set %d" %
          [coordinates[:x], coordinates[:y], values[:index] + 1]
    puts "\n"
  end

end
