module DataOutput

  # Child class of {DeltaOutput} to visualize a data set within the dimensions
  # of the calling terminal.
  class ScaledDeltaOutput < ScaledOutput

    # method to visualize the difference of two datasets
    # @param [DataSet] data_set the dataset which should be visualized
    # @param [VisMetaData] meta_data the corresponding meta data
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    # @param [Hash] options hash with the boolean values for extreme values and
    #   extended legend output
    def initialize(data_set, meta_data, indices, options)
      prepare_attributes(data_set, meta_data, options)
      @legend = ColorLegend::ColorDelta.new(@scaled_dataset.min_value,
                                            @scaled_dataset.max_value)
      print_output_head(indices)
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private

    # creates a headline before printing the data set with the requested
    # indices
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    def print_output_head(indices)
          puts "Printing autoscaled difference for datasets " \
               "#{indices[:first]} and #{indices[:second]}.\n\n"
    end

    # method to print additional information before the x and y
    # domain informations
    def print_meta_head
      puts "\nScaled Dataset: Difference of #{@meta_data.name} between the two datasets"
    end

  end

end
