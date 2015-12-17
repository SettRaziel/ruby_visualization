# @Author: Benjamin Held
# @Date:   2015-12-13 16:50:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-17 16:08:01

require_relative '../data/data_set'
require_relative '../data/data_domain'
require_relative '../graphics/color_legend'

class RegionOutput

  def self.region_output(data, coordinates, values)
    domain_x = create_data_domain("x", coordinates[:x], values[:inter],
                                                        values[:delta])
    domain_y = create_data_domain("y", coordinates[:y], values[:inter],
                                                        values[:delta])

    print_output_head(coordinates, values)
    print_data(data, domain_x, domain_y)
  end

  private

  def self.create_data_domain(label, coordinate, interval, delta)
    lower = (coordinate - interval).round(3)
    upper = (coordinate + interval + delta).round(3)

    MetaData::DataDomain.new(label, lower, upper, delta)
  end

  def self.print_data(data, domain_x, domain_y)
    legend = ColorLegend::ColorData.new(data.min_value, data.max_value)

    reversed_data = data.data.to_a.reverse.to_h

    reversed_data.each_pair { |key, row|
      DataAxis.print_y_line_beginning(domain_y, key)
      row.each_index { |index|
        print legend.create_output_string_for(row[index],'  ')
      }
      puts ''
    }
    DataAxis.print_x_axis_values(domain_x, domain_y)
    puts

    legend.print_color_legend(false)
  end

  def self.print_output_head(coordinates, values)
    puts "Printing interpolated region around (%.2f, %.2f) for data set %d" %
          [coordinates[:x], coordinates[:y], values[:index] + 1]
    puts "\n"
  end

end
