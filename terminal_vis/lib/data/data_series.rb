# @Author: Benjamin Held
# @Date:   2015-06-22 15:49:04
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-23 17:21:20

# Class to represent a series of multiple data sets
# @min_value => minimal value of the data, initial = nil
# @max_value => maximal value of the data, initial = nil
# @series => array of data sets, initial empty
class DataSeries
    attr_reader :min_value, :max_value, :series

    def initialize
        @series = Array.new()

        @min_value = nil
        @max_value = nil
    end

    # adds a data set to the array and checks if there are new
    # maximum and minimum values
    def add_data_set(data_set)
        @series << data_set

        if (@min_value == nil || @min_value > data_set.min_value)
            @min_value = data_set.min_value
        end
        if (@max_value == nil || @max_value < data_set.max_value)
            @max_value = data_set.max_value
        end
    end

end