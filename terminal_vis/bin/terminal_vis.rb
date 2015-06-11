# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-11 20:34:16

require_relative '../lib/graphics/string'
require_relative '../lib/graphics/color_legend'
require_relative '../lib/data/data_repository'
require_relative '../lib/output/output'

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

Output.new(repository.repository[2001]).print_data(2001,repository.repository[2001])
