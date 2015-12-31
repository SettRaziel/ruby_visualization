# @Author: Benjamin Held
# @Date:   2015-12-31 14:02:17
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-31 14:38:55

module DataOutput

  # Simple data output for the terminal visualization
  class DatasetOutput < Base

    # method to visualize the dataset at the index
    # @param [DataSeries] data_series the data series which should be visualized
    # @param [Integer] index the index of the desired data set
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the boolean values for extreme values and
    #   extended legend output
    def self.print_dataset(data_series, index, meta_data, options)
      @meta_data = meta_data
      set_attributes(data_series.series[index], options[:extreme_values])
      @legend = ColorLegend::ColorData.
            new(data_series.min_value, data_series.max_value)
      print_output_head(index)

      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

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
      puts "Printing difference for datasets #{indices[:first]} and " \
         "#{indices[:second]}.\n\n"
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private

    # creates a headline before printing the data set based on the values
    # of the z dimension
    # @param [Integer] index the number of the dataset
    def self.print_output_head(index)
      z_delta = index * @meta_data.domain_z.step
      puts "\nPrinting dataset for %.2f" %
            (@meta_data.domain_z.lower + z_delta)
      puts "\n"
    end

    # prints the meta information consisting of dataset name and informations
    # of the different dimensions
    def self.print_meta_information
      puts "\nDataset: #{@meta_data.name}"

      print_domain_information(@meta_data.domain_x, "\nX")
      print_domain_information(@meta_data.domain_y, 'Y')

      if (@meta_data.domain_z != nil)
        print_domain_information(@meta_data.domain_z, 'Z')
      end
    end

  end

end
