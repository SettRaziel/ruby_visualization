# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-25 19:14:48

require_relative '../lib/graphics/string'
require_relative '../lib/graphics/color_legend'
require_relative '../lib/data/data_repository'
require_relative '../lib/output/output'
require_relative '../lib/parameter/parameter_repository'

# call to determine the parameter from the argument array
def determine_parameter
    para_repo = ParameterRepository.new()
    ARGV.each { |entry|
        valid_parameter = false

        para_repo.parameter_regex.each_key { |key|
            regex = para_repo.parameter_regex[key]
            if (entry =~ regex)
                para_repo.parameter_used[key] = true
                valid_parameter = true
            end
        }

        if (!valid_parameter)
            print_error("Error: unrecognized parameter: #{entry}")
        end
    }

    if (para_repo.parameter_used.size == 0 && ARGV.length > 0)
        print_error("Error: unrecognized parameter: #{ARGV[0]}.")
    end
    return para_repo
end

# call to print the help text
def print_help
    puts "TerminalVis help:"
    puts "  --help: show help text"
    puts "      -m: process the file <filename> containing meta data"
    exit(0)
end

# call for the usage with meta data parameter -m
def apply_m(filename)
    begin
        repository = DataRepository.new()
        meta_data = repository.add_data(filename)
        Output.new(repository.repository[meta_data]).
        print_data(repository.repository[meta_data].series[0], meta_data)
    rescue Exception => e
        STDERR.puts "Error trying to use terminal_vis with option -m"
        exit(0)
    end
end

# call for the standard behavior of the script
def apply_standard(filename)
    repository = DataRepository.new()
    meta_data = repository.add_data_with_default_meta(filename)
    Output.new(repository.repository[meta_data]).
    print_data(repository.repository[meta_data].series[0], meta_data)
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

filename = ARGV[ARGV.length-1]
parameter_repo = determine_parameter()

if (ARGV.length < 1)
    message = "Invalid number of arguments: usage ruby <script> " \
    "[parameter] <filename>"
    print_error(message)
elsif (ARGV.length == 1 && parameter_repo.parameter_used["file"])
    apply_standard(filename)
else
    print_help() if (parameter_repo.parameter_used["--help"])
    apply_m(filename) if (parameter_repo.parameter_used["-m"])
end
