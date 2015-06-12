# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-12 11:44:00

require_relative '../lib/graphics/string'
require_relative '../lib/graphics/color_legend'
require_relative '../lib/data/data_repository'
require_relative '../lib/output/output'
require_relative '../lib/parameter/parameter_repository'

def determine_parameter
    para_repo = ParameterRepository.new()
    parameter = Array.new()
    para_repo.parameter_regex.each_value do |regex|
        ARGV.each do |entry|
            # puts "Found parameter: #{entry}" if entry =~ regex
            parameter << entry if entry =~ regex
        end
    end
    STDERR.puts "error: unrecognized parameter." if (parameter.length == 0 &&
        ARGV.length > 1)
    return parameter
end

def print_help
    puts "TerminalVis help:"
    puts "  --help: show help text"
    # puts "      -m: process the file <filename> containing meta data"
    exit(0)
end

def print_error
    STDERR.puts "Invalid number of arguments: usage ruby <script> " \
    "[parameter] <filename>"
    STDERR.puts "For help type: ruby <script> --help"
    exit(0)
end

begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows.'
end

if (ARGV.length < 1)
    print_error()
elsif (ARGV.length == 1 && determine_parameter().length == 0)
    filename = ARGV[ARGV.length-1]
    puts "#{ARGV[ARGV.length-1]}"
    repository = DataRepository.new(filename,2001)
    Output.new(repository.repository[2001]).
    print_data(2001,repository.repository[2001])
else
    parameter = determine_parameter()
    parameter.each do |entry|
        print_help() if (ARGV.length == 1 && entry.eql?("--help"))
        # calculate with meta data
    end
    print_error()
end
