# @Author: Benjamin Held
# @Date:   2015-08-12 18:05:53
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-05 09:36:20

require_relative '../data/data_set'

# singleton class to apply statistic methods to a data series
class DatasetStatistics

  # singleton method to calculate the differences of two datasets with
  #   result[i][j] = first_data[i][j] - second[i][j]
  # @param [DataSet] first_data data_set representing the minuend
  # @param [DataSet] second_data data_set representing the subtrahend
  # @return [DataSet] new data set with the substracted values
  def self.subtract_datasets(first_data, second_data)
    result = Array.new()

    # subtract first_data[i][j] - second_data[i][j]
    first_data.data.keys.each { |index|
      first_list = first_data.data[index]
      second_list = second_data.data[index]
      line = Array.new()
      first_list.each_index { |list_index|
        line << (first_list[list_index] - second_list[list_index])
      }
      result << line
    }

    # create new data set and return it
    DataSet.new(result)
  end

end
