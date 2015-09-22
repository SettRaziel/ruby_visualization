# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-20 10:21:55

# Output class for help text
class HelpOutput

  # method to print the help text for the given parameter
  # @param [Symbol] parameter provided parameter
  # @raise [ArgumentError] a non existent parameter is provided
  def self.print_help_for(parameter)
    if (@parameters[parameter])
      puts "TerminalVis help:".yellow
      puts @parameters[parameter]
    elsif (parameter)
      print_help
    else
      raise ArgumentError, "help entry for #{parameter} does not exist"
    end
  end

  private

  # @return [Hash] hash which stores available paramaeters and their help text
  @parameters = {
    :help =>    ' -h, --help     show help text',
    :version => ' -v, --version  prints the current version of the project',
    :all =>     ' -a, --all      ' + 'arguments:'.red + ' <speed>'.yellow +
          '; prints all possible datasets of a dataseries with a pause ' \
          'between the output of every dataset defined by speed: 0 mean ' \
          'manual, a value > 0 an animation speed in seconds, excludes -i,' \
          ' -d and -t',
    :coord =>   ' -c, --coord    ' + 'arguments:'.red + ' <x> <y>'.yellow +
          '; interpolates the data for the given coordinate (x,y) ' \
          'at default dataset index 0, excludes -e and -t',
    :delta =>   ' -d, --delta    ' + 'arguments:'.red + ' <first_index> ' \
          '<second_index>'.yellow + '; subtracts the first dataset' \
          ' from the second dataset and visualizes the difference, '\
          'excludes -a, -i and -t',
    :extreme => ' -e, --extreme  marks the extreme values in a dataset ' \
          'with ++ for a maximum and -- for a minimum, also prints ' \
          'the coordinates of the extreme values below the legend, ' \
          'excludes -c',
    :index =>   ' -i             ' + 'argument:'.red + ' <index>'.yellow +
          '; shows the dataset at index, if index lies within ' \
          '[1,2, ..., number of datasets], excludes -a, -d and -t',
    :meta =>    ' -m             process the file <filename> containing' \
          ' meta data',
    :range =>   ' -r, --range    ' + 'arguments:'.red +
          ' <start> <end>'.yellow + '; prints all datasets within the range ' \
          'of the provided arguments, excludes -a, -i, -t',
    :time =>    ' -t, --time     ' + 'arguments:'.red + ' <x> <y>'.yellow +
          '; creates a timeline for the given coordinate (x,y), coordinates ' \
          'not lying on the data point will be interpolated, excludes -a,' \
          '-c and -i'
  }

  # method to print the default help text
  def self.print_help
    puts "script usage:".red + " ruby <script> [parameters] <filename>"
    puts "help usage :".green + "              ruby <script> (-h | --help)"
    puts "help usage for parameter:".green +
       " ruby <script> <parameter> (-h | --help)"
    puts "\nTerminalVis help:".yellow

    @parameters.each_value { |value|
      puts value
    }

    print_invalid_combinations
  end

  # method to print the invalid parameter combinations
  def self.print_invalid_combinations
    puts "\nInvalid parameter combinations:".red
    puts "  -a + -d, -a + -i, -a + -t"
    puts "  -r + -a, -r + -t, -r + -i"
    puts "  -c + -e, -c + -t"
    puts "  -d + -i, -d + -t"
  end

end
