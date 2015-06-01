#!/home/benjamin/.rvm/rubies/default/bin/ruby
# @Author: Benjamin Held
# @Date:   2015-05-30 21:00:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-05-31 15:04:22

require 'csv'

class FileReader
    attr_reader :data

    def initialize(filename)
        begin
            @data = CSV.read(filename)
        rescue Exception => e
            STDERR.puts "File not found: #{filename}"
            exit(0)
        end
    end
end
