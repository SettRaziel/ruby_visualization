# @Author: Benjamin Held
# @Date:   2015-05-31 14:41:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-04 10:20:38

# Class to represent a two dimensional data set
class DataSet
  # @return [Float] the minimal value of the dataset
  attr_reader :min_value
  # @return [Float] the maximal value of the dataset
  attr_reader :max_value
  # @return [Float] the data
  attr_reader :data

  # initialization
  # @param [Array] raw_data the unformatted lines with data
  def initialize(raw_data)
    @data = Hash.new()
    process_data(raw_data)
  end

  private

  # processes the raw data and parses it in number values
  # @param [Array] raw_data the unformatted lines with data
  def process_data(raw_data)
    row = 0
    begin
      raw_data.each { |line|
        @data[row] = line.map { |s|
          Float(s)
          s.to_f }
        row += 1
      }
      find_extreme_values
    rescue Exception => e
      STDERR.puts "Error in data set: tried to parse non float argument."
      exit(0)
    end
  end

  # searches for the minimal and maximal value of the dataset
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
