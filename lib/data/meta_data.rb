# @Author: Benjamin Held
# @Date:   2015-06-09 12:49:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2019-04-09 20:17:52

require_relative '../ruby_utils/string/string'
require_relative 'data_domain'

module MetaData

  # class to store the meta information of a data series
  # @see {MetaData::MetaData} meta information format
  # @raise [IndexError] if the number of provided parameters has not
  #   the correct size
  class MetaData
    # @return [String] the name of the data
    attr_reader :name
    # @return [DataDomain] informations of the x-dimension
    attr_reader :domain_x
    # @return [DataDomain] informations of the y-dimension
    attr_reader :domain_y
    # @return [DataDomain] informations of the y-dimension
    attr_reader :domain_z

    # initialization
    # @param [Array] metadata the array with the meta information
    def initialize(metadata)

      check_element_size(metadata.length)

      @name = metadata[0]
      @domain_x = DataDomain.new(metadata[1], metadata[2], \
                     metadata[3], metadata[4])
      @domain_y = DataDomain.new(metadata[5], metadata[6], \
                     metadata[7], metadata[8])

      check_and_create_third_domain(metadata)
    end

    private

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
