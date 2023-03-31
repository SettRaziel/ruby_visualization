module DataOutput

  # Data output for the difference of two data sets for the terminal
  # visualization
  class DeltaOutput < DatasetOutput

    # method to visualize the difference of two datasets
    # @param [DataSet] data_set the dataset which should be visualized
    # @param [VisMetaData] meta_data the corresponding meta data
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    # @param [Hash] options hash with the boolean values for extreme values and
    #   extended legend output
    def initialize(data_set, meta_data, indices, options)
      @meta_data = meta_data
      set_attributes(data_set, options[:extreme_values])
      @legend = ColorLegend::ColorDelta.
                             new(data_set.min_value, data_set.max_value)

      print_output_head(indices)
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
      nil
    end

    private

    # creates a headline before printing the data set with the requested
    # indices
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    def print_output_head(indices)
      first_year = @meta_data.domain_z.lower + indices[:first]
      second_year = @meta_data.domain_z.lower + indices[:second]
      puts "Printing difference for the datasets of #{first_year} and " \
           "#{second_year}.\n\n"
      nil
    end

    # method to print additional information before the x and y
    # domain informations
    def print_meta_head
      puts "\nDataset: Difference of #{@meta_data.name} between two datasets"
      nil
    end

  end

end
