# @Author: Benjamin Held
# @Date:   2015-05-31 14:41:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-18 17:06:43

# Class to represent a two dimensional data set
# @min_value => minimal value of the data
# @max_value => maximal value of the data
# @data => the data
class DataSet
    attr_reader :min_value, :max_value, :data

    def initialize(raw_data)
        @data = Hash.new()
        process_data(raw_data)
    end

    private

    # processes the raw data and parses it in number values
    # @data => parsed data
    def process_data(raw_data)
        row = 0
        begin
            raw_data.each { |line|
                @data[row] = line.map { |s|
                    Float(s)
                    s.to_f }
                row += 1
            }
            find_extreme_values()
        rescue Exception => e
            STDERR.puts "Error in data set: tried to parse non float argument."
            exit(0)
        end
    end

    # searches fot the minimal and maximal value
    # @min_value => minimal value of the data set
    # @max_value => maximal value of the data set
    def find_extreme_values
        @min_value = @data[0][1].to_f
        @max_value = @data[0][1].to_f
        data.each_value { |row|
            row.each { |value|
                @min_value = value if (value < @min_value)
                @max_value = value if (value > @max_value)
            }
        }
    end
end