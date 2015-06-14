# @Author: Benjamin Held
# @Date:   2015-05-30 21:00:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-13 22:10:51

require 'csv'

class FileReader
    attr_reader :data

    def initialize(filename)
        begin
            @data = CSV.read(filename)
        rescue Exception
            STDERR.puts "File not found: #{filename}"
            exit(0)
        end
    end
end
