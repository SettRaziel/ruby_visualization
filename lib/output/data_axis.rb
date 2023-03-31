require_relative "../data/data_domain"

# Output class to create the data axis for the dataset and delta output
# in the x- and y-dimension
class DataAxis

  # initialization
  def initialize
    @max_y_indentation = 0
  end

  # method to print the legend for the x-axis
  # @param [DataDomain] domain_x the data domain used for the x-axis values
  def print_x_axis_values(domain_x)
    x_value_lenght = determine_maximal_domainvalue_length(domain_x)
    print_x_axis_markings(domain_x)
    print_x_axis_init(domain_x)
    index = 5
    while ((x_value_lenght / 2 + index) <= domain_x.number_of_values)
      extend_x_axis_output(index, domain_x)
      index += 5
    end
  end

  # method to print the legend of the y axis and the start of a line
  # @param [DataDomain] domain the data domain in y
  # @param [Integer] key the index of the dataset in y
  def print_y_line_beginning(domain, key)
    max_length = determine_maximal_domainvalue_length(domain) + 1

    output = determine_y_axis_init(domain, key)
    (max_length - output.length).times { output.concat(" ") }
    @max_y_indentation = output.length if (@max_y_indentation < output.length)
    print output
  end

  private
  # attribute to store the maximal needed indentation for the y scale
  attr :max_y_indentation

  # method to print axis markings to see which visualized point belongs to the
  # coordinate of the axis values
  # @param [DataDomain] domain_x the data domain used for the x-axis values
  def print_x_axis_markings(domain_x)
    (@max_y_indentation).times { print " "}
    index = 0
    print "\\/"
    while (index < domain_x.number_of_values / 5)
      8.times { print "-"}
      print "\\/"
      index += 1
    end
    puts
  end

  # singleton method to print the initial string of the x axis description
  # @param [DataDomain] domain_x the data domain used for the x-axis values
  def print_x_axis_init(domain_x)
    (@max_y_indentation).times { print " "}
    value = "#{domain_x.get_coordinate_to_index(0).round(3)}"
    print "%#{value.length}s" % "#{value}"
  end

  # method to print the empty gap between two values of the x-axis and the
  # following value
  # @param [Integer] index the index of the data coordinate which should be
  #   printed
  # @param [DataDomain] domain the data domain of the x-axis
  def extend_x_axis_output(index, domain)
    value = "#{domain.get_coordinate_to_index(index).round(3)}"
    (10 - value.length).times { print " " }
    print "%#{value.length}s" % "#{value}"
  end

  # method to determine the maximal string length of a {MetaData::DataDomain}
  # value
  # @param [DataDomain] domain the considered domain
  # @return [Integer] the maximal lenght of a string in this domain
  def determine_maximal_domainvalue_length(domain)
    sizes = [ "#{(domain.lower + domain.step).round(3)}".length,
              "#{(domain.upper + domain.step).round(3)}".length,
              "#{domain.lower}".length, "#{domain.upper}".length]
    return sizes.sort.last
  end

  # method to determine if the coordinate of the current y value should be
  # printed or the corresponding number blanks
  # @param [DataDomain] domain the data domain of the y-axis
  # @param [Integer] key the index of the current line
  # @return [String] the current y coordinate or an empty string
  def determine_y_axis_init(domain, key)
    if (key % 5 == 0 || key == domain.number_of_values)
      return "#{domain.get_coordinate_to_index(key).round(3)}"
    else
      return String.new()
    end
  end

end
