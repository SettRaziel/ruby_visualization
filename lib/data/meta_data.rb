# @Author: Benjamin Held
# @Date:   2015-06-09 12:49:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2020-01-16 19:56:51

require_relative '../ruby_utils/string/string'
require_relative '../ruby_utils/data/meta_data'
require_relative 'data_domain'

module MetaData

  # class to store the meta information of a data series
  # @see {MetaData::MetaData} meta information format
  # @raise [IndexError] if the number of provided parameters has not
  #   the correct size
  class VisMetaData < MetaData
    # @return [String] the name of the data
    attr_reader :name
    # @return [DataDomain] informations of the x-dimension
    attr_reader :domain_x
    # @return [DataDomain] informations of the y-dimension
    attr_reader :domain_y
    # @return [DataDomain] informations of the y-dimension
    attr_reader :domain_z

    private

    # method which parses the required meta information from the 
    # head line
    # @param [Object] header_line the head line of a data set holding the 
    # relevant meta information
    def parse_header(header_line)
      check_element_size(header_line.length)

      @name = header_line[0]
      @domain_x = DataDomain.new(header_line[1], header_line[2], \
                     header_line[3], header_line[4])
      @domain_y = DataDomain.new(header_line[5], header_line[6], \
                     header_line[7], header_line[8])

      check_and_create_third_domain(header_line)
    end

    # method to check the correct number of parameters for the meta data
    # @param [Integer] size the size of the metadata array
    # @raise [IndexError] if the number of provided parameters has not
    #   the correct size
    def check_element_size(size)
      if !(size == 13 || size == 9)
        raise IndexError, " Error in meta data: incorrect number of" \
                  " arguments: #{size}.".red
      end
    end

    # method to check if the meta data array contains information for a third
    # dimension and read these data if available
    # @param [Array] metadata the array with the meta data information
    def check_and_create_third_domain(metadata)
      if (metadata.length == 13)
        @domain_z = DataDomain.new(metadata[9], metadata[10], \
                       metadata[11], metadata[12])
      else
        @domain_z = nil
      end
    end

  end

end
