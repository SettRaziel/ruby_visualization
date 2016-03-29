# @Author: Benjamin Held
# @Date:   2016-01-29 10:17:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-29 15:17:16

module DataOutput

  # Child class of {DatasetOutput} to visualize a data set within the dimensions
  # of the calling terminal.
  class ScaledDatasetOutput < DatasetOutput

    require_relative '../../scaling/terminal_size'
    require_relative '../../scaling/dataset_scaling'

    # method to print a given dataset scaled by the terminal size
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def self.print_dataset(data_set, meta_data, options)
      # read terminal size from options hash
      prepare_attributes(data_set, meta_data, options)
      print_output_head(options[:index], meta_data)
      # call print_data of the the parent class
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private

    # method to set the required attributes und create the scaled dataset
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def self.prepare_attributes(data_set, meta_data, options)
      # create meta data and data set for the scaled output
      sc = DatasetScaling.new(meta_data, data_set)
      @meta_data = sc.scaled_meta
      @legend = ColorLegend::ColorData.new(sc.scaled_data_set.min_value,
                                           sc.scaled_data_set.max_value)
      set_attributes(sc.scaled_data_set, options[:extreme_values])
    end

    # creates a headline before printing the data set based on the values
    # of the z dimension
    # @param [Integer] index the number of the dataset
    def self.print_output_head(index, meta_data)
      puts "\nPrinting autoscaled dataset for %.2f" %
            (meta_data.domain_z.lower + (index * meta_data.domain_z.step))
      puts "\n"
    end

  end

end
