# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-10 17:06:48

require_relative '../data/file_reader'
require_relative 'data_set'
require_relative 'meta_data'

class DataRepository
    attr_reader :repository

    def initialize
        @repository = Hash.new()
    end

    def initialize(filename)
        initialize()
        add_data(filename)
    end

    def initialize(filename,key)
        @repository = Hash.new()
        @repository[key] = create_dataset(read_file(filename))
    end

    def add_data(filename)
        @data = read_file(filename)
        meta_data = check_for_metadata()
        @repository[meta_data] = create_dataset(@data)
    end


    private

    def create_dataset(data)
        DataSet.new(data)
    end

    attr :data

    def read_file(filename)
        FileReader.new(filename).data
    end


    def check_for_metadata()
        meta_string = @data[0]
        @data.delete_at(1)
        @data.delete_at(0)
        MetaData.new(meta_string)
    end
end
