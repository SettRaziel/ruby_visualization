# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-06 11:07:34

require_relative './graphics/string'
require_relative './graphics/color_legend'
require_relative './data/data_repository'
require_relative './output/output'

begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows'
end

if (ARGV.length != 1)
    STDERR.puts "Invalid number of arguments: usage ruby <script> <filename>"
    exit(0)
end

filename = ARGV[0]

repository = DataRepository.new(filename,2001)

Output.new(repository.repository[2001]).print_data(repository.repository[2001])
