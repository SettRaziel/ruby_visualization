# @Author: Benjamin Held
# @Date:   2015-05-31 14:41:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-02 22:20:44

class DataSet
    attr_reader :min_value, :max_value, :data

    def initialize(raw_data)
        @data = Hash.new()
        process_data(raw_data)
    end

    private

    def process_data(raw_data)
        row = 0
        raw_data.each { |line|
            @data[row] = line.map { |s| s.to_f }
            row += 1
        }
        find_extreme_values()
    end

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
