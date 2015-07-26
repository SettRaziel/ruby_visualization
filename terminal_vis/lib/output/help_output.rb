# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-26 13:35:17

# Output class for help text
class HelpOutput

    # method to print the default help text
    def self.print_help
        puts "usage: ruby <script> [parameters] <filename>"
        puts "\nTerminalVis help:"
        puts " -h, --help     show help text"
        puts " -v, --version  prints the current version of the project"
        puts " -m             process the file <filename> containing meta data"
        puts " -i <index>     shows the dataset at index, if index lies " \
             "within [1,2, ..., number of datasets], excludes -a, --all"
        puts " -a, --all      prints all possible datasets of a dataseries " \
             "with a pause between the output of every dataset, excludes -i."
    end

    # method to print the help text for the given parameter
    # raises ArgumentError when a non existent parameter is provided
    def self.print_help_for(parameter)
        if (@parameters[parameter])
            puts @parameters[parameter]
        else
            raise ArgumentError, "help entry for #{parameter} does not exist"
        end
    end

    private

    # hash which stores available paramaeters and their help text
    @parameters = {
        '-h' => ' -h, --help     show help text',
        '--help' => ' -h, --help     show help text',
        '-v' => ' -v, --version  prints the current version of the project',
        '--version' => ' -v, --version  prints the current version of the' \
                       ' project',
        '-m' => ' -m             process the file <filename> containing' \
                ' meta data',
        '-i' => ' -i <index>     shows the dataset at index, if index lies ' \
                'within [1,2, ..., number of datasets], excludes -a, --all',
        '-a' => ' -a, --all      prints all possible datasets of a ' \
                ' dataseries with a pause between the output of every ' \
                'dataset, excludes -i',
        '-all' => ' -a, --all      prints all possible datasets of a ' \
                ' dataseries with a pause between the output of every ' \
                'dataset, excludes -i'
    }

end
