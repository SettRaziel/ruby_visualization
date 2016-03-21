# @Author: Benjamin Held
# @Date:   2015-12-31 14:02:17
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-24 16:30:35

module DataOutput

  # Simple data output for the terminal visualization and a dataset
  class DatasetOutput < Base

    # method to visualize the dataset at the index
    # @param [DataSeries] data_series the data series which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the boolean values for extreme values and
    #   extended legend output
    def self.print_dataset(data_series, meta_data, options)
      @meta_data = meta_data
      set_attributes(data_series.series[options[:index]],
                     options[:extreme_values])
      @legend = ColorLegend::ColorData.
                             new(data_series.min_value, data_series.max_value)

      print_output_head(options[:index])
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private
    # @return [MetaData] the meta data for this output
    attr :meta_data

    # creates a headline before printing the data set based on the values
    # of the z dimension
    # @param [Integer] index the number of the dataset
    def self.print_output_head(index)
      puts "\nPrinting dataset for %.2f" %
            (@meta_data.domain_z.lower + (index * @meta_data.domain_z.step))
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
