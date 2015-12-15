# @Author: Benjamin Held
# @Date:   2015-09-12 09:52:39
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-15 14:34:42

require_relative '../data/data_domain'

# Output class to create the data axis for the dataset and delta output
# in the x- and y-dimension
class DataAxis

  # method to print the legend for the x-axis
  # @param [DataDomain] domain_x the data domain used for the x-axis values
  # @param [DataDomain] domain_y the data domain used for the y-axis values
  def self.print_x_axis_values(domain_x, domain_y)
    x_value_lenght = determine_maximal_domainvalue_length(domain_x)
    print_x_axis_init(domain_x, domain_y)
    index = 5
    while ((x_value_lenght / 2 + index) <= domain_x.number_of_values)
      extend_x_axis_output(10 - x_value_lenght, index, domain_x)
      index += 5
    end
  end

  # method to print the legend of the y axis and the start of a line
  # @param [DataDomain] domain the data domain in y
  # @param [Integer] key the index of the dataset in y
  def self.print_y_line_beginning(domain, key)
    max_length = determine_maximal_domainvalue_length(domain) + 1

    output = determine_y_axis_init(domain, key)
    (max_length - output.length).times { output.concat(' ') }
    print output
  end

  private

  # singleton method to print the initial string of the x axis description
  # @param [DataDomain] domain_x the data domain used for the x-axis values
  # @param [DataDomain] domain_y the data domain used for the y-axis values
  def self.print_x_axis_init(domain_x, domain_y)
    y_offset = determine_maximal_domainvalue_length(domain_y)
    extend_x_axis_output(y_offset, 0, domain_x)
  end

  # method to print the empty gap between two values of the x-axis and the
  # following value
  # @param [Integer] length the space between two entries
  # @param [Integer] index the index of the data coordinate which should be
  #   printed
  # @param [DataDomain] domain the data domain of the x-axis
  def self.extend_x_axis_output(length, index, domain)
    length.times { print ' ' }
    value_lenght = determine_maximal_domainvalue_length(domain)
    print ("%#{value_lenght}s") % "#{domain.get_coordinate_to_index(index).
                                            round(3)}"
  end

  # method to determine the maximal string length of a data domain value
  # @param [DataDomain] domain the considered domain
  # @return [Integer] the maximal lenght of a string in this domain
  def self.determine_maximal_domainvalue_length(domain)
    lower_length = "#{domain.lower}".length
    upper_length = "#{domain.upper}".length

    return lower_length if (lower_length >= upper_length)
    return upper_length
  end

  # method to determine if the coordinate of the current y value should be
  # printed or the corresponding number blanks
  # @param [DataDomain] domain the data domain of the y-axis
  # @param [Integer] key the index of the current line
  # @return [String] the current y coordinate or an empty string
  def self.determine_y_axis_init(domain, key)
    if (key % 5 == 0 || key == domain.number_of_values)
      return "#{domain.get_coordinate_to_index(key).round(3)}"
    else
      return String.new()
    end
  end

end
