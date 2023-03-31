module DataInput

  # Class to represent a series of multiple data sets with the extreme values
  # of the whole data series
  class DataSeries
    # @return [Float] minimal value of the data, initial = nil
    attr_reader :min_value
    # @return [Float] maximal value of the data, initial = nil
    attr_reader :max_value
    # @return [Array] Array of data sets, initial empty
    attr_reader :series

    # initialization
    # min_value and max_value are initialized with nil because the extreme
    # values are not necessarily present at this moment
    def initialize
      @series = Array.new()

      @min_value = nil
      @max_value = nil
    end

    # adds a data set to the array and checks if there are new
    # maximum and minimum values
    # @param [DataSet] data_set {DataSet} that should be added to the series
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

end
