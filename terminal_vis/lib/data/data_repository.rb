# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-30 09:07:12

require_relative '../data/file_reader'
require_relative 'data_set'
require_relative 'data_series'
require_relative 'meta_data'

# data repository storing the read data and handling the meta information
# @repository => Hash of metadata and the corresponding data set or
# data series
class DataRepository
    attr_reader :repository

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
    def add_data_with_default_meta(filename)
        @data = read_file(filename)
        data_series = create_dataset()

        if (data_series.series.size > 1)
            meta_string = ["#{filename}", \
                           "X", 0, data_series.series[0].data[0].size, 1, \
                           "Y", 0, data_series.series[0].data.size, 1, \
                           "Z", 0, data_series.series.size, 1]
        else
            meta_string = ["#{filename}", \
                            "X", 0, data_series.series[0].data[0].size, 1, \
                            "Y", 0, data_series.series[0].data.size, 1]
        end

        meta_data = MetaData.new(meta_string)
        @repository[meta_data] = data_series
        return meta_data
    end

    private

    attr :data

    # creates DataSets of the parsed data and stores it into a DataSeries
    def create_dataset()
        data = Array.new()
        value = DataSeries.new()

        # parse multiple data sets (but at least 1)
        @data.each { |line|
            if (line.empty?)
                value.add_data_set(DataSet.new(data))
                data = Array.new()
            else
                data << line
            end
        }

        # get the last data set, since the loop ended before putting it there
        value.add_data_set(DataSet.new(data))
        return value
    end

    # calls the FileReader to get the content of the file
    def read_file(filename)
        FileReader.new(filename).data
    end

    # checks for meta data in the first line of the raw data and creates
    # meta information from it
    def check_for_metadata()
        meta_string = @data[0]
        @data.delete_at(1)
        @data.delete_at(0)
        MetaData.new(meta_string)
    end

    # checks if a given key already exists in the repository
    def check_for_existenz(key)
        if (@repository[key] != nil)
                puts "Info: A data set with this key already exists." \
                     " Overwriting..."
        end
    end
end
