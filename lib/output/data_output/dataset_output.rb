# @Author: Benjamin Held
# @Date:   2016-04-10 14:48:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2020-01-16 19:27:25

module DataOutput

  # Parent class for data output and delta output
  class DatasetOutput < BaseOutput

    private
    # @return [VisMetaData] the meta data for this output
    attr :meta_data

    # prints the meta information consisting of dataset name and informations
    # of the different dimensions
    def print_meta_information
      print_meta_head

      print_domain_information(@meta_data.domain_x, "\nX")
      print_domain_information(@meta_data.domain_y, 'Y')

      print_meta_tail
      nil
    end

    # abstract method to print additional information before the x and y
    # domain informations
    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def print_meta_head
      fail NotImplementedError, " Error: the subclass #{self.class} needs " \
           "to implement the method: print_meta_tail " \
           "from its base class".red
    end

    # method to print additional information after the x and y
    # domain informations
    def print_meta_tail
      nil # do nothing
    end
  end

end
