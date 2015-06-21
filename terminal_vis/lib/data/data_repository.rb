# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-21 19:02:45

require_relative '../data/file_reader'
require_relative 'data_set'
require_relative 'meta_data'


class DataRepository
    attr_reader :repository

    def initialize(filename = nil,key = nil)
        @repository = Hash.new()
        add_data(filename) if (key == nil && filename != nil)
        if (filename != nil && key != nil)
            check_for_existenz(key)
            @repository[key] = create_dataset(read_file(filename))
        end
    end

    def add_data(filename)
        @data = read_file(filename)
        meta_data = check_for_metadata()
        check_for_existenz(meta_data)
        @repository[meta_data] = create_dataset(@data)
        @data = nil
        return meta_data
    end

    def add_data_with_default_meta(filename)
        data_set = create_dataset(read_file(filename))
        meta_string = ["#{filename}", "X", 0, data_set.data[0].size, 1, \
                       "Y", 0, data_set.data.size, 1]
        meta_data = MetaData.new(meta_string)
        @repository[meta_data] = data_set
        return meta_data
    end

    private

    attr :data

    def create_dataset(data)
        # parse multiple data sets
        DataSet.new(data)
    end

    def read_file(filename)
        FileReader.new(filename).data
    end

    def check_for_metadata()
        meta_string = @data[0]
        @data.delete_at(1)
        @data.delete_at(0)
        MetaData.new(meta_string)
    end

    def check_for_existenz(key)
        if (@repository[key] != nil)
                puts "Info: A data set with this key already exists." \
                     " Overwriting..."
        end
    end
end
