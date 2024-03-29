module DataOutput

  # Child class of {DatasetOutput} to visualize a data set within the dimensions
  # of the calling terminal.
  class ScaledOutput < DatasetOutput

    private
    # @return [DataSet] the scaled dataset
    attr :scaled_dataset

    # method to set the required attributes und create the scaled dataset
    # @param [DataSet] data_set the data set which should be visualized
    # @param [VisMetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def prepare_attributes(data_set, meta_data, options)
      # create meta data and data set for the scaled output
      sc = DatasetScaling.new(meta_data, data_set)
      @meta_data = sc.scaled_meta
      @scaled_dataset = sc.scaled_data_set
      set_attributes(@scaled_dataset, options[:extreme_values])
    end

    # creates a headline before printing the data set based on the values
    # of the z dimension
    # @param [Integer] index the number of the dataset
    def print_output_head(index, meta_data)
      puts "\nPrinting autoscaled dataset for %.2f" %
            (meta_data.domain_z.lower + (index * meta_data.domain_z.step))
      puts "\n"
    end

  end

end
