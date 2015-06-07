# @Author: Benjamin Held
# @Date:   2015-05-31 14:28:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-03 10:49:09

require_relative '../data/file_reader'
require_relative 'data_set'

class DataRepository
    attr_reader :repository

    def initialize
        @repository = Hash.new()
    end

    def initialize(filename,key)
        @repository = Hash.new()
        create_dataset(filename,key)
    end

    def create_dataset(filename,key)
        data = FileReader.new(filename).data
        data_set = DataSet.new(data)
        @repository[key] = data_set
    end
end
