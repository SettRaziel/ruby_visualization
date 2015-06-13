# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-13 21:57:51

require_relative '../data/file_reader'
require_relative 'data_set'
require_relative 'meta_data'


class DataRepository
    attr_reader :repository

    def initialize(filename = nil,key = nil)
        @repository = Hash.new()
        add_data(filename) if (key == nil && filename != nil)
        if (filename != nil && key != nil)
            @repository[key] = create_dataset(read_file(filename))
        end
    end

    def add_data(filename)
        @data = read_file(filename)
        meta_data = check_for_metadata()
        @repository[meta_data] = create_dataset(@data)
        return meta_data
    end

    private

    attr :data

    def create_dataset(data)
        DataSet.new(data)
    end

    def read_file(filename)
        FileReader.new(filename).data
    end

    def check_for_metadata()
        meta_string = @data[0]
        # check for failure if -m is set but no meta data found
        @data.delete_at(1)
        @data.delete_at(0)
        MetaData.new(meta_string)
    end
end
