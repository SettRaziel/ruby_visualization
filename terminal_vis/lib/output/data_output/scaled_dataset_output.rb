# @Author: Benjamin Held
# @Date:   2016-01-29 10:17:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-14 17:01:04

module DataOutput

  # Child class of {DatasetOutput} to visualize a data set within the dimensions
  # of the calling terminal.
  class ScaledDatasetOutput < ScaledOutput

    # method to print a given dataset scaled by the terminal size
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def self.print_dataset(data_set, meta_data, options)
      prepare_attributes(data_set, meta_data, options)
      @legend = ColorLegend::ColorData.new(@scaled_dataset.min_value,
                                           @scaled_dataset.max_value)
      print_output_head(options[:index], meta_data)
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private

    # creates a headline before printing the data set based on the values
    # of the z dimension
    # @param [Integer] index the number of the dataset
    def self.print_output_head(index, meta_data)
      puts "\nPrinting autoscaled dataset for %.2f" %
            (meta_data.domain_z.lower + (index * meta_data.domain_z.step))
      puts "\n"
    end

    # method to print additional information before the x and y
    # domain informations
    def self.print_meta_head
        puts "\nScaled Dataset: #{@meta_data.name}"
    end

    # method to print additional information after the x and y
    # domain informations
    def self.print_meta_tail
      if (@meta_data.domain_z != nil)
        print_domain_information(@meta_data.domain_z, 'Z')
      end
    end

  end

end
