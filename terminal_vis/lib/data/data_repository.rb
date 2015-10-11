# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-11 15:01:40

require_relative '../data/file_reader'
require_relative 'data_set'
require_relative 'data_series'
require_relative 'meta_data'

# This class serves as a data repository storing the read data and handling the
# meta information
class DataRepository
  # @return Hash mapping {MetaData} -> {DataSeries}
  attr_reader :repository

  # initialization
  # @param [String] filename filepath
  # @param [MetaData] key key for the data series
  def initialize(filename = nil,key = nil)
    @repository = Hash.new()
    add_data(filename) if (key == nil && filename != nil)
    if (filename != nil && key != nil)
      check_for_existenz(key)
      read_file(filename)
      @repository[key] = create_dataset()
    end
  end

  # reads the file and creates meta information and data of its content
  # @param [String] filename filepath
  # @return [MetaData] the meta data object for this data
  def add_data(filename)
    @data = read_file(filename)
    meta_data = check_for_metadata()
    check_for_existenz(meta_data)
    @repository[meta_data] = create_dataset()
    @data = nil
    return meta_data
  end

  # reads the file and creates data of its content with default meta
  # information
  # @param [String] filename filepath
  # @return [MetaData] the meta data object for this data
  def add_data_with_default_meta(filename)
    @data = read_file(filename)
    data_series = create_dataset()
    meta_string = build_meta_string(data_series, filename)

    meta_data = MetaData::MetaData.new(meta_string)
    @repository[meta_data] = data_series
    return meta_data
  end

  # checks if all data sets in a data_series have the dimension specified
  # in the meta_data information
  # @param [MetaData] meta_data the meta data which should be checked
  # @return [boolean] true, if data fulfills the information provded by the
  #   meta data; false, if one data dimension of the number of datasets fails
  def data_complete?(meta_data)
    dataset_dimension_correct?(meta_data) || z_dimension_correct?(meta_data)
  end

  # checks if the dimension of each dataset is consistent with the information
  # of the corresponding meta data
  # @param [MetaData] meta_data the meta data which should be checked
  # @return [boolean] true, if the dimension of every dataset is consistent
  #   with the meta information; false, if not
  def dataset_dimension_correct?(meta_data)
    data_series = @repository[meta_data]
    number_value_x = meta_data.domain_x.number_of_values
    number_value_y = meta_data.domain_y.number_of_values

    data_series.series.each_with_index { |data_set, index|
      number_data_x = data_set.data[0].size
      number_data_y = data_set.data.size

      if (number_value_x != number_data_x ||
        number_value_y != number_data_y)
        puts " Warning: Size of dataset #{index + 1} does not match " \
             "with meta data information."
        puts "   meta_data: #{number_value_x}, #{number_value_y}"
        puts "   data_set: #{number_data_x}, #{number_data_y}"
        return false
      end
    }

    return true
  end

  # checks if all data sets in a data_series have the dimension in z specified
  # in the meta_data information
  # @param [MetaData] meta_data the meta data which should be checked
  # @return [boolean] true, if number of dataset is consistent with the meta
  #   information; false, if not
  def z_dimension_correct?(meta_data)
    data_series = @repository[meta_data]
    number_value_z = meta_data.domain_z.number_of_values
    number_data_z = data_series.series.size

    if (number_value_z != number_data_z)
      puts " Warning: Size of dataseries does not match with" \
         " meta data information."
      puts "   meta_data: #{number_value_z} datasets to data_series: " \
         "#{number_data_z} datasets"
      return false
    end

    return true
  end

  private
  # @return [Array] the read data from a file
  attr :data

  # creates DataSets of the parsed data and stores it into a DataSeries
  # @return [DataSeries] the data series created by the data input
  def create_dataset
    raw_data = Array.new()
    value = DataSeries.new()

    # parse multiple data sets (but at least 1)
    @data.each { |line|
      if (line.empty?)
        value.add_data_set(DataSet.new(raw_data))
        raw_data = Array.new()
      else
        raw_data << line
      end
    }

    # get the last data set, since the loop ended before putting it there
    value.add_data_set(DataSet.new(raw_data))
    return value
  end

  # method to build the meta string that is uses for default meta data
  # @param [DataSeries] data_series the given data series
  # @param [String] filename the name of the input file
  # @return [Array] the constructed meta string
  def build_meta_string(data_series, filename)
    meta_string = ["#{filename}", \
                   "X", 0, data_series.series[0].data[0].size - 1, 1, \
                   "Y", 0, data_series.series[0].data.size - 1, 1]

    if (data_series.series.size > 1)
      meta_string.concat( ["Z", 1, data_series.series.size, 1] )
    end

    return meta_string
  end

  # calls the FileReader to get the content of the file
  # @param [String] filename filepath
  # @return [Array] the data of the file as strings
  def read_file(filename)
    FileReader.new(filename, ',').data
  end

  # checks for meta data in the first line of the raw data and creates
  # meta information from it
  # @return [MetaData] the meta data for the data series
  def check_for_metadata
    meta_string = @data[0]
    @data.delete_at(1)
    @data.delete_at(0)
    MetaData::MetaData.new(meta_string)
  end

  # checks if a given key already exists in the repository
  # @param [MetaData] key key that should be checked
  def check_for_existenz(key)
    if (@repository[key] != nil)
        puts "Info: A data set with this key already exists." \
           " Overwriting..."
    end
  end

end
