# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-07 15:22:52

# Output class for help text
class HelpOutput

  # method to print the help text for the given parameter
  # @param [Symbol] parameter provided parameter
  # @raise [ArgumentError] a non existent parameter is provided
  def self.print_help_for(parameter)
    initialize_output if (@parameters == nil)
    if (@parameters[parameter])
      puts "TerminalVis help:".yellow + "\n#{@parameters[parameter]}"
    elsif (parameter)
      print_help
    else
      raise ArgumentError, "help entry for #{parameter} does not exist"
    end
  end

  private

  # @return [Hash] hash which stores available parameters and their help text
  attr_reader :parameters

  # method to initialize the hash containing the help entries
  def self.initialize_output
    @parameters = Hash.new()
    add_single_help_entries
    add_one_argument_help_entries
    add_two_argument_help_entries
  end

  # method to specify and add the help entries with help text only
  def self.add_single_help_entries
    add_simple_text(:help, ' -h, --help     show help text')
    add_simple_text(:version,
                    ' -v, --version  prints the current version of the project')
    add_simple_text(:extreme,
                    ' -e, --extreme  marks the extreme values in a dataset ' \
                    'with ++ for a maximum and -- for a minimum, also prints ' \
                    'the coordinates of the extreme values below the legend, ' \
                    'excludes -c')
    add_simple_text(:meta, ' -m             process the file <filename> ' \
                    'containing meta data')
  end

  # method to specify and add the help entries with help text and one argument
  def self.add_one_argument_help_entries
    add_single_argument_text(:all, ' -a, --all      ', ' <speed>',
          '; prints all specified datasets of a dataseries with a pause ' \
          'between the output of every dataset defined by speed: 0 mean ' \
          'manual, a value > 0 an animation speed in seconds, excludes -i,' \
          ' -d and -t')
    add_single_argument_text(:index, ' -i             ', ' <index>',
          '; shows the dataset at index, if index lies within ' \
          '[1,2, ..., number of datasets], excludes -a, -d and -t')
    add_single_argument_text(:option, ' -o, --options  ', ' <option>',
          '; enables options, the source depends on the argument: '\
          'file=<filename> loads options from file, menu enables the '\
          'possibility to input the desired values')
  end

  # method to specify and add the help entries with help text and two arguments
  def self.add_two_argument_help_entries
    add_dual_argument_text(:coord, ' -c, --coord    ', ' <x> <y>',
          '; interpolates the data for the given coordinate (x,y) ' \
          'at default dataset index 0, excludes -e and -t')
    add_dual_argument_text(:delta, ' -d, --delta    ',
          ' <first_index> <second_index>',
          '; subtracts the first dataset from the second dataset and ' \
          'visualizes the difference, excludes -a, -i and -t')
    add_dual_argument_text(:range, ' -r, --range    ', ' <start> <end>',
          '; prints all datasets within the range of the provided ' \
          'arguments, excludes -i, -t')
    add_dual_argument_text(:time, ' -t, --time     ', ' <x> <y>',
          '; creates a timeline for the given coordinate (x,y), coordinates ' \
          'not lying on the data point will be interpolated, excludes -a,' \
          ' -c, and -i')
  end

  # method to add a (key, value) pair to the parameter hash
  # @param [Symbol] symbol the key
  # @param [String] text the value containing a formatted string
  def self.add_simple_text(symbol, text)
    @parameters[symbol] = text
  end

  # method to add a (key, value) pair where the value contains help text
  # with one argument
  # @param [Symbol] symbol the key
  # @param [String] argument the string part containing the argument
  # @param [String] parameter the string part containing the required parameter
  # @param [String] text the string part containing the description text
  def self.add_single_argument_text(symbol, argument, parameter, text)
    add_simple_text(symbol, build_entry(argument, 'argument:',
                                        parameter, text))
  end

  # method to add a (key, value) pair where the value contains help text
  # with two argument
  # @param [Symbol] symbol the key
  # @param [String] argument the string part containing the argument
  # @param [String] parameters the string part containing the
  #   required parameters
  # @param [String] text the string part containing the description text
  def self.add_dual_argument_text(symbol, argument, parameters, text)
    add_simple_text(symbol, build_entry(argument, 'arguments:',
                                        parameters, text))
  end

  # method to build the entry text when dealing with one ore more parameters
  # @param [String] parameter the string part containing the required paramter
  # @param [String] quantity string entry to reflect the number of parameters
  # @param [String] argument the string part containing the argument
  # @param [String] text the string part containing the description text
  # @return [String] the complete string representing the help entry
  def self.build_entry(parameter, quantity, argument, text)
    parameter + quantity.red + argument.yellow + text
  end

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
    print_configuration_parameter
  end

  # method to print the invalid parameter combinations
  def self.print_invalid_combinations
    puts "\nInvalid parameter combinations:".red
    puts "  -a + -d, -a + -i, -a + -t"
    puts "  -r + -t, -r + -i"
    puts "  -c + -e, -c + -t"
    puts "  -d + -i, -d + -t"
  end

  # method to print the available configuration parameter
  def self.print_configuration_parameter
    puts "\nAvailable configuration parameter:".red
    puts "Timeline:".yellow + " number of interval steps in y-dimension [5,100]"
    puts "Color legend:".yellow + " extended informations about the intervals"
  end

end
