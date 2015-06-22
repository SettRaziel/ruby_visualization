# @Author: Benjamin Held
# @Date:   2015-06-22 15:49:04
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-22 16:23:43

class DataSeries
    attr_reader :min_value, :max_value, :data

    def initialize()
        @data = Array.new()

        @min_value = nil
        @max_value = nil
    end

    def add_data_set(data_set)
        @data << data_set

        if (@min_value == nil || @min_value > data_set.min_value)
            @min_value = data_set.min_value
        end
        if (@max_value == nil || @max_value < data_set.max_value)
            @max_value = data_set.max_value
        end
    end

end
