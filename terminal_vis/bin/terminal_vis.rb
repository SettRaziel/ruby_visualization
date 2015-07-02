# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-02 12:28:45

require_relative '../lib/graphics/string'
require_relative '../lib/graphics/color_legend'
require_relative '../lib/data/data_repository'
require_relative '../lib/output/output'
require_relative '../lib/parameter/parameter_repository'

# call to print the help text
def print_help
    puts "TerminalVis help:"
    puts " -h, --help     show help text"
    puts " -v, --version  prints the current version of the project"
    puts " -m             process the file <filename> containing meta data"
    puts " -i <index>     shows the dataset at index, if index lies within" \
                          " [1,2, ..., number of datasets]"
    exit(0)
end

# call to print version number and author
def print_version
    puts "terminal_visualization version 0.1"
    puts "Created by Benjamin Held (June 2015)"
    exit(0)
end

# call for the usage with meta data parameter -m
def apply_m(filename)
    begin
        meta_data = @data_repository.add_data(filename)
        index = get_and_check_index(meta_data)
        Output.new(@data_repository.repository[meta_data]).
        print_data(@data_repository.repository[meta_data].
                    series[index], meta_data)
    rescue Exception => e
        STDERR.puts "Error trying to use terminal_vis with option -m"
        exit(0)
    end
end

# call for the standard behavior of the script
def apply_standard(filename)
    meta_data = @data_repository.add_data_with_default_meta(filename)
    index = get_and_check_index(meta_data)
    Output.new(@data_repository.repository[meta_data]).
    print_data(@data_repository.repository[meta_data].series[index], meta_data)
end

# checks if option -i was used and determines if a valid parameter was entered
# default return is 0
def get_and_check_index(meta_data)
    index = 0   # default data set if -i not set or only one data set
    if (@parameter_repository.parameters[:index])
        begin   # make sure that parameter of -i is an integer
            index = Integer(@parameter_repository.parameters[:index]) - 1
        rescue ArgumentError
            message = "ArgumentError: argument of -i is not a number:" \
                      "#{@parameter_repository.parameters[:index]}"
            print_error(message)
        end

        # check if provided integer index lies in range of dataseries
        if (index < 0 ||
            index >= @data_repository.repository[meta_data].series.size)
            text_index = @parameter_repository.parameters[:index]
            data_size = @data_repository.repository[meta_data].series.size
            message = "Error: input #{text_index} for -i is not valid" \
                      "for dataset with length #{data_size}"
            print_error(message)
        end
    end

    return index
end

# call for standard error output
def print_error(message)
    STDERR.puts "#{message}"
    STDERR.puts "For help type: ruby <script> --help"
    exit(0)
end

#-------------------------------------------------------------------------------
# Terminal Visualization Script
# Version 0.1
# created by Benjamin Held, June 2015
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows.'
end

@parameter_repository = ParameterRepository.new(ARGV)
@data_repository = DataRepository.new()
print_version() if (@parameter_repository.parameters[:version])
print_help() if (@parameter_repository.parameters[:help])

@parameter_repository.check_for_valid_filepath()


if (ARGV.length < 1)
    message = "Invalid number of arguments: usage ruby <script> " \
    "[parameters] <filename>"
    print_error(message)
elsif (!@parameter_repository.parameters[:meta])
    apply_standard(@parameter_repository.parameters[:file])
else
    apply_m(@parameter_repository.parameters[:file])
end
