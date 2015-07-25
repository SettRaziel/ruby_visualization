# @Author: Benjamin Held
# @Date:   2015-07-25 12:17:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-25 12:28:41

# Output class for help text
class HelpOutput

    # methode to print the default help text
    def self.print_help
        puts "usage: ruby <script> [parameters] <filename>"
        puts "\nTerminalVis help:"
        puts " -h, --help     show help text"
        puts " -v, --version  prints the current version of the project"
        puts " -m             process the file <filename> containing meta data"
        puts " -i <index>     shows the dataset at index, if index lies within " \
                              "[1,2, ..., number of datasets], excludes -a, --all"
        puts " -a, --all      prints all possible datasets of a dataseries with " \
                              "a pause between the output of every dataset, " \
                              "excludes -i."
    end

end
