# @Author: Benjamin Held
# @Date:   2015-05-30 21:00:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-03 09:59:47

require 'csv'

# Simple file reader using the csv library to read a csv file
# requires csv
# @raise [IOError] if csv throws an exception
class FileReader
  attr_reader :data

  # initialization
  # @param [String] filename filepath of the file which should be read
  # @raise [IOError] if an error occurs while the file is read
  def initialize(filename)
    begin
      @data = CSV.read(filename)
    rescue Exception => e
      raise IOError, e.message.concat(".")
    end
  end

end
