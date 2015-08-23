# @Author: Benjamin Held
# @Date:   2015-08-12 18:05:53
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-20 10:39:37

# singleton class to apply statistic methods to a data series
class DatasetStatistics

  # singleton method to calculate the differences of two datasets with
  # result[i][j] = first_data[i][j] - second[i][j]
  # first_data => data_set representing the minuend
  # second_data => data_set representing the subtrahend
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