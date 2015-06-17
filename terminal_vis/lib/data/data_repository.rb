# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-17 17:44:15

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
