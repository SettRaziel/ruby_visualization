# @Author: Benjamin Held
# @Date:   2016-03-22 14:15:01
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-23 12:31:34

module DataOutput

  # Child class of {DeltaOutput} to visualize a data set within the dimensions
  # of the calling terminal.
  class ScaledDeltaOutput < DeltaOutput

    require_relative '../../scaling/terminal_size'
    require_relative '../../scaling/dataset_scaling'

    # method to visualize the difference of two datasets
    # @param [DataSet] data_set the dataset which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    # @param [Hash] options hash with the boolean values for extreme values and
    #   extended legend output
    def self.print_delta(data_set, meta_data, indices, options)
      prepare_attributes(data_set, meta_data, options)
      print_output_head(indices)
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private

    # method to set the required attributes und create the scaled dataset
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def self.prepare_attributes(data_set, meta_data, options)
      # create meta data and data set for the scaled output
      sc = DatasetScaling.new(meta_data)
      @meta_data = sc.scaled_meta
      scaled_data_set = sc.calculate_scaled_dataset(data_set)

      @legend = ColorLegend::ColorDelta.new(scaled_data_set.min_value,
                                            scaled_data_set.max_value)
      set_attributes(scaled_data_set, options[:extreme_values])
    end

    # creates a headline before printing the data set with the requested
    # indices
    # @param [Hash] indices the indices of the two datasets which should be
    #   substracted
    def self.print_output_head(indices)
          puts "Printing autoscaled difference for datasets " \
               "#{indices[:first]} and #{indices[:second]}.\n\n"
    end

  end

end
