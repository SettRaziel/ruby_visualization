# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-06-26 18:09:06

require_relative '../data/file_reader'
require_relative 'data_set'
require_relative 'data_series'
require_relative 'meta_data'

# This class serves as a data repository storing the read data and handling the
# meta information
class DataRepository
  # @return Hash mapping {MetaData::MetaData} -> {DataSeries}
  attr_reader :repository

  # initialization
  # @param [String] filename filepath
  # @param [MetaData] key key for the data series
  def initialize(filename = nil,key = nil)
    @repository = Hash.new()
    add_data_with_default_meta(filename) if (key == nil && filename != nil)
    if (filename != nil && key != nil)
      data = read_file(filename)
      @repository[key] = create_dataseries(data)
    end
  end

  # reads the file and creates meta information and data of its content
  # @param [String] filename filepath
  # @return [MetaData] the meta data object for this data
  def add_data(filename)
    data = read_file(filename)
    meta_data = check_for_metadata(data)
    check_for_existenz(meta_data)
    @repository[meta_data] = create_dataseries(data)
    return meta_data
  end

  # reads the file and creates data of its content with default meta
  # information
  # @param [String] filename filepath
  # @return [MetaData] the meta data object for this data
  def add_data_with_default_meta(filename)
    data = read_file(filename)
    data_series = create_dataseries(data)
    meta_string = build_meta_string(data_series, filename)

    meta_data = MetaData::MetaData.new(meta_string)
    @repository[meta_data] = data_series
    return meta_data
  end

  # checks if all data sets in a data_series have the dimension specified
  # in the {MetaData::MetaData} information
  # @param [MetaData] meta_data the meta data which should be checked
  # @return [boolean] true, if data fulfills the information provded by the
  #   meta data; false, if one data dimension of the number of datasets fails
  def data_complete?(meta_data)
    dataset_dimension_correct?(meta_data) || z_dimension_correct?(meta_data)
  end

  # checks if the dimension of each dataset is consistent with the information
  # of the corresponding {MetaData::MetaData}
  # @param [MetaData] meta_data the meta data which should be checked
  # @return [boolean] true, if the dimension of every dataset is consistent
  #   with the meta information; false, if not
  def dataset_dimension_correct?(meta_data)
    domain_values = get_domain_values(meta_data)

    @repository[meta_data].series.each_with_index { |data_set, index|
      data_values = get_data_values(data_set)

      if (domain_values[:x] != data_values[:x] ||
          domain_values[:y] != data_values[:y])
        print_domain_mismatch(index, domain_values, data_values)
        return false
      end
    }

    return true
  end

  # method to retrieve the number of data values in the x and y dimension based
  # on the {MetaData::MetaData} information
  # @param [MetaData] meta_data the meta data whose values should be used
  # @return [Hash] a hash containing the number of data values in x and y
  def get_domain_values(meta_data)
    domain_values = Hash.new()
    domain_values[:x] = meta_data.domain_x.number_of_values
    domain_values[:y] = meta_data.domain_y.number_of_values
    return domain_values
  end

  # method to retireve the number of data values in the x and y dimension based
  # on the size of the {DataSet}
  # @param [DataSet] data_set the dataset that should be checked
  # @return [Hash] a hash containing the number of data values in x and y
  def get_data_values(data_set)
    data_values = Hash.new()
    data_values[:x] = data_set.data[0].size
    data_values[:y] = data_set.data.size
    return data_values
  end

  # method to print a warning if the dimension of the meta data does not fit
  # with the dimension of the actual dataset
  # @param [Integer] index the index of the dataset in the given data series
  # @param [Hash] domain_values a hash containing the number of data values in
  #   x and y based on the meta data
  # @param [Hash] data_values a hash containing the number of data values in
  #   x and y based on the dataset
  def print_domain_mismatch(index, domain_values, data_values)
    puts " Warning: Size of dataset #{index + 1} does not match " \
         "with meta data information.".yellow
    puts "   meta_data: #{domain_values[:x]}, #{domain_values[:y]}".yellow
    puts "   data_set: #{data_values[:x]}, #{data_values[:y]}".yellow
  end

  # checks if all data sets in a data_series have the dimension in z specified
  # in the {MetaData::MetaData} information
  # @param [MetaData] meta_data the meta data which should be checked
  # @return [boolean] true, if number of dataset is consistent with the meta
  #   information; false, if not
  def z_dimension_correct?(meta_data)
    data_series = @repository[meta_data]
    number_value_z = meta_data.domain_z.number_of_values
    number_data_z = data_series.series.size

    if (number_value_z != number_data_z)
      puts ' Warning: Size of dataseries does not match with' \
         ' meta data information.'.yellow
      puts "   meta_data: #{number_value_z} datasets to data_series: " \
         "#{number_data_z} datasets".yellow
      return false
    end

    return true
  end

  private

  # creates {DataSet}s of the parsed data and stores it into a {DataSeries}
  # @param [Array] data the read data
  # @return [DataSeries] the data series created by the data input
  def create_dataseries(data)
    raw_data = Array.new()
    value = DataSeries.new()

    # parse multiple data sets (but at least 1)
    data.each { |line|
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

  # method to build the meta string that is uses for default
  #   {MetaData::MetaData}
  # @param [DataSeries] data_series the given data series
  # @param [String] filename the name of the input file
  # @return [Array] the constructed meta string
  def build_meta_string(data_series, filename)
    meta_string = ["#{filename}", \
                   'X', 0, data_series.series[0].data[0].size - 1, 1, \
                   'Y', 0, data_series.series[0].data.size - 1, 1]

    if (data_series.series.size > 1)
      meta_string.concat( ['Z', 1, data_series.series.size, 1] )
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
  # @param [Array] data the read data
  # @return [MetaData] the meta data for the data series
  def check_for_metadata(data)
    meta_string = data[0]
    data.delete_at(1)
    data.delete_at(0)
    MetaData::MetaData.new(meta_string)
  end

  # checks if a given key already exists in the repository
  # @param [MetaData] key key that should be checked
  def check_for_existenz(key)
    if (@repository[key] != nil)
        puts 'Info: A data set with this key already exists. Overwriting...'
    end
  end

end
