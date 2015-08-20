# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-20 10:44:09

# Output class for help text
class HelpOutput

  # method to print the help text for the given parameter
  # raises ArgumentError when a non existent parameter is provided
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

  # hash which stores available paramaeters and their help text
  @parameters = {
    :help =>    ' -h, --help     show help text',
    :version => ' -v, --version  prints the current version of the project',
    :all =>     ' -a, --all      prints all possible datasets of a ' \
          ' dataseries with a pause between the output of every ' \
          'dataset, excludes -i',
    :coord =>   ' -c, --coord    ' + 'arguments:'.red + ' <x> <y>'.yellow +
          '; interpolates the data for the given coordinate (x,y) ' \
          'at default dataset index 0, can be combined with -i',
    :delta =>   ' -d, --delta    ' + 'arguments:'.red + ' <first_index> ' \
          '<second_index>'.yellow + '; subtracts the first dataset' \
          ' from the second dataset and visualizes the difference',
    :extreme => ' -e, --extreme  marks the extreme values in a dataset ' \
          'with ++ for a maximum and -- for a minimum, also prints ' \
          'the coordinates of the extreme values below the legend',
    :index =>   ' -i             ' + 'argument:'.red + ' <index>'.yellow +
          '; shows the dataset at index, if index lies within ' \
          '[1,2, ..., number of datasets], excludes -a, --all',
    :meta =>    ' -m             process the file <filename> containing' \
          ' meta data'
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
  end

end
