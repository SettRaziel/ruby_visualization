# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-30 17:45:47

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
        Output.new(@data_repository.repository[meta_data]).
        print_data(@data_repository.repository[meta_data].series[0], meta_data)
    rescue Exception => e
        STDERR.puts "Error trying to use terminal_vis with option -m"
        exit(0)
    end
end

# call for the standard behavior of the script
def apply_standard(filename)
    meta_data = @data_repository.add_data_with_default_meta(filename)
    Output.new(@data_repository.repository[meta_data]).
    print_data(@data_repository.repository[meta_data].series[0], meta_data)
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
elsif (ARGV.length == 1 && @parameter_repository.parameters[:file])
    apply_standard(@parameter_repository.parameters[:file])
else
    if (@parameter_repository.parameters[:meta])
        apply_m(@parameter_repository.parameters[:file])
    end
end
