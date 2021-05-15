require 'ruby_utils/string'
require_relative '../data/meta_data'

# This class holds methods to print a previously created timelime into the
# terminal providing simple axis for the z dimension on the abscissa and the
# data values on the ordinate.
class TimelineOutput

  # initialization
  # @param [Hash] mapped_values the output hash from {Timeline} mapping boundary
  #  values to z values
  # @param [VisMetaData] meta_data the meta information of the regarded data series
  # @param [Hash] values the mapping of the required start values
  def initialize(mapped_values, meta_data, values)
    @extrema = {
      :maximum => Array.new(),
      :minimum => Array.new()
    }
    output = create_output_array(mapped_values, meta_data)

    print_output_head(values[:x],values[:y])

    output.reverse.each { |value|
      puts value
    }
  end

  attr_reader :extrema

  private

  # simple method for printing an output haeder
  # @param [Float] x x-coordinate of the regarded point
  # @param [Float] y y-coordinate of the regarded point
  def print_output_head(x,y)
    puts "\nPrinting timeline for Coordinate (%.2f, %.2f)" % [x, y]
    puts "\n"
    nil
  end

  # method to create the output array, consisting of a string for each line
  # holding ordinate values and markings for the values and two additional lines
  # for the abscissa
  # @param [Hash] mapped_values the output hash from {Timeline} mapping boundary
  #  values to z values
  # @param [VisMetaData] meta_data the meta information of the regarded data series
  # @return [Array] array with the strings for each line
  def create_output_array(mapped_values, meta_data)
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

    append_legend_output(output, meta_data, max_size)
  end

  # method to append the axis and legend information below the timeline
  # @param [Array] output the String array containing the output
  # @param [VisMetaData] meta_data the used meta data
  # @param [Integer] max_size the number ob padding white spaces
  # @return [Array] the String array containing the output appended by the
  #  legend output
  def append_legend_output(output, meta_data, max_size)
    data_size = meta_data.domain_z.number_of_values
    output.unshift(create_axis_string(data_size, max_size))
    output.unshift(create_axis_legend(data_size, max_size, meta_data))
    output.unshift(create_extreme_output(max_size))
  end

  # method to finish the creation of a line of timeline output
  # @param [Array] values values for one line of the output
  # @param [String] line_string the started string that serves as output for
  #  one line
  # @return [String] the extended line string
  def check_and_append_values(values, line_string)
    values.each { |value|
        if (value[0] == :miss)
          line_string.concat(' ')
        else
          line_string.concat(check_type_and_print(value))
        end
    }
    return line_string
  end

  # method to create the axis of the abscissa
  # @param [Integer] data_size the number of values in the z dimension
  # @param [Integer] max_size length of the greates number on the ordinate
  # @return [String] the output string for the abscissa
  def create_axis_string(data_size, max_size)
    str = String.new()
    max_size.times {str.concat(' ')}
    str.concat('--|')
    position = 1

    while (data_size - position >= 10)
      str.concat('---------|')
      position += 10
    end
    (data_size - position).times {str.concat('-')}
    str.concat('|')
  end

  # method to create value informations for the abscissa
  # @param [Integer] data_size the number of values in the z dimension
  # @param [Integer] max_size length of the greates number on the ordinate
  # @param [VisMetaData] meta_data the meta information of the regarded data series
  # @return [String] the value informations for the abscissa
  def create_axis_legend(data_size, max_size, meta_data)
    str = String.new()
    max_size.times {str.concat(' ')}
    position = 1
    start = Integer(meta_data.domain_z.lower)

    while (data_size - position >= 10)
      str.concat("%-10s" % start.to_s)
      position += 10
      start += Integer((10 * meta_data.domain_z.step).round(1))
    end
    str.concat(finish_axis_legend(data_size - position, start, meta_data))
  end

  # method to finish the axis legend string
  # @param [Integer] puffer the number of rest characters
  # @param [Integer] start the current number of the axis
  # @param [VisMetaData] meta_data the meta information of the regarded data series
  # @return [String] the ending of the axis legend
  def finish_axis_legend(puffer, start, meta_data)
    str = ("%-#{puffer}s" % start.to_s)
    if (puffer > 5)
      str.concat(Integer(meta_data.domain_z.upper).to_s)
    end
    str
  end

  # method to create the output of the extreme values
  # @param [Integer] max_size the number of padding white strings
  # @return [String] the output string for the extreme values
  def create_extreme_output(max_size)
    str = String.new()
    max_size.times {str.concat(' ')}
    str.concat("Maximum: #{@extrema[:maximum].round(3)}\n")
    max_size.times {str.concat(' ')}
    str.concat("Minimum: #{@extrema[:minimum].round(3)}")
  end

  # method to check the type of hit
  # @param [Array] value an array containing information of the hit and
  #  the value if it is an extreme value
  # @return [String] the corresponding output string
  def check_type_and_print(value)
    if (value[0] == :maximum)
      @extrema[:maximum] = value[1]
      return 'x'.red.bright
    elsif (value[0] == :minimum)
      @extrema[:minimum] = value[1]
      return 'x'.cyan.bright
    end

    'x'.green
  end

end
