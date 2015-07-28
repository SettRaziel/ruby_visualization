# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-28 13:11:05

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
        :help => ' -h, --help     show help text',
        :version => ' -v, --version  prints the current version of the project',
        :meta => ' -m             process the file <filename> containing' \
                 ' meta data',
        :index => ' -i <index>     shows the dataset at index, if index lies ' \
                  'within [1,2, ..., number of datasets], excludes -a, --all',
        :all => ' -a, --all      prints all possible datasets of a ' \
                ' dataseries with a pause between the output of every ' \
                'dataset, excludes -i',
    }

    # method to print the default help text
    def self.print_help
        puts "script usage:".red + " ruby <script> [parameters] <filename>"
        puts "help usage :".green + "              ruby <script> (-h | --help)"
        puts "help usage for parameter:".green +
             " ruby <script> <parameter> (-h | --help)"
        puts "\nTerminalVis help:".yellow
        puts " -h, --help     show help text"
        puts " -v, --version  prints the current version of the project"
        puts " -m             process the file <filename> containing meta data"
        puts " -i <index>     shows the dataset at index, if index lies " \
             "within [1,2, ..., number of datasets], excludes -a, --all"
        puts " -a, --all      prints all possible datasets of a dataseries " \
             "with a pause between the output of every dataset, excludes -i."
    end

end
