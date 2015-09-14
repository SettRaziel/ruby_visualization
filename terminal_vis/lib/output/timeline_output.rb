# @Author: Benjamin Held
# @Date:   2015-08-25 13:40:23
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-14 17:32:35

require_relative '../graphics/string'

# This class holds methods to print a previously created timelime into the
# terminal providing simple axis for the z dimension on the abscissa and the
# data values on the ordinate.
class TimelineOutput

  # public singleton method to create the output for the terminal
  # @param [Hash] mapped_values the output hash from {Timeline} mapping boundary
  #  values to z values
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @param [Float] x x-coordinate of the regarded point
  # @param [Float] y y-coordinate of the regarded point
  def self.print_timeline(mapped_values, meta_data, x, y)
    output = create_output_array(mapped_values, meta_data)

    print_output_head(x,y)

    output.reverse.each { |value|
      puts value
    }

  end

  private

  # simple method for printing an output haeder
  # @param [Float] x x-coordinate of the regarded point
  # @param [Float] y y-coordinate of the regarded point
  def self.print_output_head(x,y)
    puts "\nPrinting timeline for Coordinate (%.2f, %.2f)" % [x, y]
    puts "\n"
  end

  # method to create the output array, consisting of a string for each line
  # holding ordinate values and markings for the values and two additional lines
  # for the abscissa
  # @param [Hash] mapped_values the output hash from {Timeline} mapping boundary
  #  values to z values
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @return [Array] array with the strings for each line
  def self.create_output_array(mapped_values, meta_data)
    output = Array.new()
    max_size = ("%.2f" % mapped_values.keys.last).length

    mapped_values.each_pair { |key, values|
      line_string = "%.2f" % (key)
      if (line_string.length <= max_size)
        (max_size - line_string.length).times { line_string.concat(' ')}
      end
      line_string.concat('| ')
      output << check_and_append_values(values, line_string)
    }

    data_size = meta_data.domain_z.upper - meta_data.domain_z.lower
    output.unshift(create_axis_string(data_size, max_size))
    output.unshift(create_axis_legend(data_size, max_size, meta_data))

    return output
  end

  # method to finish the creation of a line of timeline output
  # @param [Array] values values for one line of the output
  # @param [String] line_string the started string that serves as output for
  #  one line
  # @return [String] the extended line string
  def self.check_and_append_values(values, line_string)
    values.each { |value|
        if (value == 1)
          line_string.concat('x'.green)
        else
          line_string.concat(' ')
        end
      }
      return line_string
  end

  # method to create the axis of the abscissa
  # @param [Integer] data_size the number of values in the z dimension
  # @param [Integer] max_size length of the greates number on the ordinate
  # @return [String] the output string for the abscissa
  def self.create_axis_string(data_size, max_size)
    str = String.new()
    max_size.times {str.concat(' ')}
    str.concat('--|')
    position = 1

    while (position < data_size)
      str.concat('---------|')
      position += 10
    end

    return str
  end

  # method to create value informations for the abscissa
  # @param [Integer] data_size the number of values in the z dimension
  # @param [Integer] max_size length of the greates number on the ordinate
  # @param [MetaData] meta_data the meta information of the regarded data series
  # @return [String] the value informations for the abscissa
  def self.create_axis_legend(data_size, max_size, meta_data)
    str = String.new()
    max_size.times {str.concat(' ')}
    position = 1
    start = meta_data.domain_z.lower

    while (position < data_size)
      str.concat("%-10s" % start.to_s)
      position += 10
      start += 10
    end
    str.concat("%-10s" % start.to_s)

    return str
  end

end
