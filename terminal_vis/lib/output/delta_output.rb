# @Author: Benjamin Held
# @Date:   2016-01-12 09:30:35
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-01-12 09:45:19

module DataOutput

  # Data output for the difference of two data sets for the terminal
  # visualization
  class DeltaOutput < Base

    # method to visualize the difference of two datasets
    # @param [DataSet] data_set the dataset which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    # @param [Hash] options hash with the boolean values for extreme values and
    #   extended legend output
    def self.print_delta(data_set, meta_data, indices, options)
      @meta_data = meta_data
      set_attributes(data_set, options[:extreme_values])
      @legend = ColorLegend::ColorDelta.
                             new(data_set.min_value, data_set.max_value)

      print_output_head(indices)
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private
    # @return [MetaData] the meta data for this output
    attr :meta_data

    # creates a headline before printing the data set with the requested
    # indices
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    def self.print_output_head(indices)
          puts "Printing difference for datasets #{indices[:first]} and " \
         "#{indices[:second]}.\n\n"
    end

    # prints the meta information consisting of dataset name and informations
    # of the different dimensions
    def self.print_meta_information
      puts "\nDataset: Difference of #{@meta_data.name} between two datasets"

      print_domain_information(@meta_data.domain_x, "\nX")
      print_domain_information(@meta_data.domain_y, 'Y')
    end

  end

end
