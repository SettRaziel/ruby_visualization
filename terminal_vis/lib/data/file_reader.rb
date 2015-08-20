# @Author: Benjamin Held
# @Date:   2015-05-30 21:00:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-20 10:42:09

require 'csv'

# Simple file reader using the csv library to read a csv file
# requires csv
# raises IOError if csv throws an exception
class FileReader
  attr_reader :data

  # initialization
  # filename => filepath of the file which should be read
  def initialize(filename)
    begin
      @data = CSV.read(filename)
    rescue Exception => e
      raise IOError, e.message.concat(".")
    end
  end

end
