# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2020-01-13 17:43:29

require_relative '../ruby_utils/help/help_output'

# Output class for help text
class HelpOutput < BasicHelpOutput

  private

  # method to specify and add the help entries with help text only
  def self.add_single_help_entries
    add_simple_text(:extreme,
                    ' -e, --extreme  ', 'marks the extreme values in a ' \
                    'dataset with ++ for a maximum and -- for a minimum, ' \
                    'also prints the coordinates of the extreme values below' \
                    ' the legend, excludes -c')
    add_simple_text(:meta, ' -m, --meta     ', 'process the file <filename> ' \
                    'containing meta data')
  end

  # method to specify and add the help entries with help text and one argument
  def self.add_one_argument_help_entries
    add_single_argument_text(:all, ' -a, --all      ', ' <speed>',
          '; prints all specified datasets of a dataseries with a pause ' \
          'between the output of every dataset defined by speed: 0 means ' \
          'manual, a value > 0 an animation speed in seconds, excludes -i,' \
          ' -d and -t')
    add_single_argument_text(:index, ' -i, --index    ', ' <index>',
          '; shows the dataset at index, if index lies within ' \
          '[1,2, ..., # datasets], excludes -a, -d and -t')
    add_single_argument_text(:option, ' -o, --options  ', ' <option>',
          '; enables options, the source depends on the argument: '\
          'file=<filename> loads options from <filename>, menu enables the '\
          'possibility to input the desired values')
  end

  # method to specify and add the help entries with help text and two arguments
  def self.add_two_argument_help_entries
    add_dual_argument_text(:coord, ' -c, --coord    ', ' <x> <y>',
          '; interpolates the data for the given coordinate (x,y) ' \
          'with default dataset index 0, excludes -e, -a, -r and -t')
    add_dual_argument_text(:delta, ' -d, --delta    ',
          ' <first_index> <second_index>',
          '; subtracts the first dataset from the second dataset and ' \
          'visualizes the difference, indices as [1,2, ..., # ' \
          'datasets], excludes -a, -i and -t')
    add_dual_argument_text(:range, ' -r, --range    ', ' <start> <end>',
          '; prints all datasets within the range of the provided ' \
          'arguments, indices as [1,2, ..., # datasets], excludes -i, -t')
    add_dual_argument_text(:section, ' -s, --section  ',
          ' <interval> <delta>', '; interpolates data for a given region, ' \
          'specified by a coordinate, an interval and stepwidth; result: ' \
          'interpolated values in (x+-interval, y+-interval) with stepwidth ' \
          'delta, excludes -a, -r and -t; requires -c')
    add_dual_argument_text(:time, ' -t, --time     ', ' <x> <y>',
          '; creates a timeline for the given coordinate (x,y), coordinates ' \
          'not laying on the data point will be interpolated, excludes -a,' \
          ' -c, and -i')
  end 

  # method to print the default help text
  def self.print_help_head
    puts 'script usage:'.red + " ruby <script> [parameters] <filename>"
    puts 'help usage :'.green + "              ruby <script> (-h | --help)"
    puts 'help usage for parameter:'.green +
       " ruby <script> <parameter> (-h | --help)"
    puts "\n#{get_script_name} help:".light_yellow
  end

  # method to print the invalid parameter combinations
  def self.print_invalid_combinations
    puts "\nInvalid parameter combinations:".red
    puts '  -a + -d, -a + -i, -a + -t'
    puts '  -r + -t, -r + -i'
    puts '  -c + -e, -c + -t'
    puts '  -d + -i, -d + -t'
  end

  # method to print the available configuration parameter
  def self.print_configuration_parameter
    puts "\nAvailable configuration parameter:".red
    puts 'Timeline:'.blue + ' number of interval steps in y-dimension [5,100]'
    puts 'Color legend:'.blue + ' extended informations about the intervals'
    puts 'Scaling:'.blue + ' automatic scaling of the output to the size of ' \
         'the calling terminal (atm standard dataset output, e.g. -i only)'
  end

  # method to set the name of the script project
  def self.get_script_name
      "TerminalVis"
  end

end
