# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-18 12:47:57


require_relative '../lib/data/data_repository'
require_relative '../lib/output/output'
require_relative '../lib/parameter/parameter_repository'

# call to print the help text
def print_help
    puts "usage: ruby <script> [parameters] <filename>"
    puts "\nTerminalVis help:"
    puts " -h, --help     show help text"
    puts " -v, --version  prints the current version of the project"
    puts " -m             process the file <filename> containing meta data"
    puts " -i <index>     shows the dataset at index, if index lies within" \
                          " [1,2, ..., number of datasets]"
    puts " -a, --all      prints all possible datasets of a dataseries with " \
                          "a pause between the output of every dataset."
    exit(0)
end

# call to print version number and author
def print_version
    puts "terminal_visualization version 0.2"
    puts "Created by Benjamin Held (June 2015)"
    exit(0)
end

# call for the usage with meta data parameter -m
def apply_m(filename)
    begin
        meta_data = @data_repository.add_data(filename)
        create_output(meta_data)
    rescue Exception => e
        print_error(e.message.concat(" Error while using option -m."))
    end
end

# call for the standard behavior of the script
def apply_standard(filename)
    meta_data = @data_repository.add_data_with_default_meta(filename)
    create_output(meta_data)
end

# creates output based on metadata and parameters
def create_output(meta_data)
    if (@parameter_repository.parameters[:all])
        data_series = @data_repository.repository[meta_data]
        data_series.series.each_index { |index|
            create_single_output_at_index(meta_data, index)
            print "press Enter to continue ..."
            # STDIN to read from console when providing parameters in ARGV
            STDIN.gets.chomp
        }
    else
        index = get_and_check_index(meta_data)
        create_single_output_at_index(meta_data, index)
    end
    @data_repository.check_data_completeness(meta_data)
end

# creates default output or output with an index using -i
def create_single_output_at_index(meta_data, index)
    Output.new(@data_repository.repository[meta_data]).
    print_data(@data_repository.repository[meta_data].series[index],
               index, meta_data)
end

# checks if option -i was used, determines if a valid parameter was entered
# and returns the index on success
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
                      " for dataset with length #{data_size}"
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
# Version 0.2
# created by Benjamin Held, June 2015
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows.'
end

if (ARGV.length < 1)
    message = "Invalid number of arguments: usage ruby <script> " \
    "[parameters] <filename>"
    print_error(message)
end

begin
    @parameter_repository = ParameterRepository.new(ARGV)
    @data_repository = DataRepository.new()
    print_version() if (@parameter_repository.parameters[:version])
    print_help() if (@parameter_repository.parameters[:help])

    @parameter_repository.check_for_valid_filepath()

    if (!@parameter_repository.parameters[:meta])
        apply_standard(@parameter_repository.parameters[:file])
    else
        apply_m(@parameter_repository.parameters[:file])
    end
rescue ArgumentError => e
    print_error(e.message)
end
