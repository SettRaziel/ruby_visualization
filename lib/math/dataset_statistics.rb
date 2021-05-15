require_relative '../data/data_input'

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
    DataInput::DataSet.new(result)
  end

end
