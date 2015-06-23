# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-23 17:22:06

require_relative '../lib/graphics/string'
require_relative '../lib/graphics/color_legend'
require_relative '../lib/data/data_repository'
require_relative '../lib/output/output'
require_relative '../lib/parameter/parameter_repository'

# call to determine the parameter from the argument array
def determine_parameter
    para_repo = ParameterRepository.new()
    parameter = Array.new()
    para_repo.parameter_regex.each_value do |regex|
        ARGV.each do |entry|
            # puts "Found parameter: #{entry}" if entry =~ regex
            parameter << entry if entry =~ regex
        end
    end
    STDERR.puts "Error: unrecognized parameter." if (parameter.length == 0 &&
        ARGV.length > 1)
    return parameter
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
def print_error
    STDERR.puts "Invalid number of arguments: usage ruby <script> " \
    "[parameter] <filename>"
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

if (ARGV.length < 1)
    print_error()
elsif (ARGV.length == 1 && determine_parameter().length == 0)
    apply_standard(filename)
else
    parameter = determine_parameter()
    parameter.each do |entry|
        print_help() if (ARGV.length == 1 && entry.eql?("--help"))
        apply_m(filename) if (entry.eql?("-m"))
    end
end
