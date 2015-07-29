# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-29 09:42:25


require_relative '../lib/data/data_repository'
require_relative '../lib/output/data_output'
require_relative '../lib/output/help_output'
require_relative '../lib/parameter/parameter_handler'

# call to print the help text
def print_help
    HelpOutput.print_help_for(@parameter_handler.repository.parameters[:help])
    exit(0)
end

# call to print version number and author
def print_version
    puts "terminal_visualization version 0.3.1"
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
    if (@parameter_handler.repository.parameters[:all])
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
    DataOutput.print_data(@data_repository.repository[meta_data],
                          index, meta_data)
end

# checks if option -i was used, determines if a valid parameter was entered
# and returns the index on success
# default return is 0
def get_and_check_index(meta_data)
    index = 0   # default data set if -i not set or only one data set
    if (@parameter_handler.repository.parameters[:index])
        begin   # make sure that parameter of -i is an integer
            index =
                   Integer(@parameter_handler.repository.parameters[:index]) - 1
        rescue ArgumentError
            message = "ArgumentError: argument of -i is not a number:" \
                      "#{@parameter_handler.repository.parameters[:index]}"
            print_error(message)
        end

        # check if provided integer index lies in range of dataseries
        if (index < 0 ||
            index >= @data_repository.repository[meta_data].series.size)
            text_index = @parameter_handler.repository.parameters[:index]
            data_size = @data_repository.repository[meta_data].series.size
            message = " Error: input #{text_index} for -i is not valid" \
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
# Version 0.3.1
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
    @parameter_handler = ParameterHandler.new(ARGV)
    @data_repository = DataRepository.new()
    print_help() if (@parameter_handler.repository.parameters[:help])
    print_version() if (@parameter_handler.repository.parameters[:version])

    if (!@parameter_handler.repository.parameters[:meta])
        apply_standard(@parameter_handler.repository.parameters[:file])
    else
        apply_m(@parameter_handler.repository.parameters[:file])
    end
rescue ArgumentError => e
    print_error(e.message)
end
