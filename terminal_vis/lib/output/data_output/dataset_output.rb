# @Author: Benjamin Held
# @Date:   2016-04-10 14:48:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-10 15:10:15

module DataOutput

  # Parent class for data output and delta output
  class DatasetOutput < Base

    private
    # @return [MetaData] the meta data for this output
    attr :meta_data

    # prints the meta information consisting of dataset name and informations
    # of the different dimensions
    def self.print_meta_information
      print_meta_head

      print_domain_information(@meta_data.domain_x, "\nX")
      print_domain_information(@meta_data.domain_y, 'Y')

      print_meta_tail
    end

    # abstract method to print additional information before the x and y
    # domain information
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def self.print_meta_head
      fail NotImplementedError, " Error: the subclass #{self.class} needs " \
           "to implement the method: print_meta_tail " \
           "from its base class".red
    end

    # method to print additional information before the x and y
    # domain information
    def self.print_meta_tail
      # do nothing
    end
  end

end
