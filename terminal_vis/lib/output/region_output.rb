# @Author: Benjamin Held
# @Date:   2015-12-13 16:50:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-03 18:11:12

module DataOutput

  # Output class to visualize the interpolation of a region
  class RegionOutput < Base

    # singleton method to generate the output for the given region
    # @param [DataSet] data the data that should be visualized
    # @param [Hash] coordinates a hash containing the x and y coordinate of the
    #   central point of the region
    # @param [Hash] values a hash containing all required values to interpolate
    #   the region
    def self.region_output(data, coordinates, values)
      set_attributes(data, values[:extreme_values])
      @legend = ColorLegend::ColorData.new(data.min_value, data.max_value)
      @domain_x = create_data_domain('X', coordinates[:x], values[:inter],
                                                          values[:delta_x])
      @domain_y = create_data_domain('Y', coordinates[:y], values[:inter],
                                                          values[:delta_y])

      print_output_head(coordinates, values)
      print_data(values[:legend], @domain_x, @domain_y)
    end

    private
    # @return {DataDomain} representing the section in the x-dimension
    attr :domain_x
    # @return {DataDomain} representing the section in the y-dimension
    attr :domain_y

    # method to create the special data domains for the x- and y-dimension
    # @param [String] label the name of the domain
    # @param [Float] coordinates the coordinate of the region center in the
    #   required dimension
    # @param [Float] interval the value to specify the value set in the
    #   considered dimension
    # @param [Float] delta the steprange in the considered dimension
    # @return [DataDomain] the domain object based on the input parameter
    def self.create_data_domain(label, coordinate, interval, delta)
      lower = (coordinate - interval).round(3)
      upper = (coordinate + interval + delta).round(3)

      MetaData::DataDomain.new(label, lower, upper, delta)
    end

    # method to print the output head
    # @param [Hash] coordinates a hash containing the coordinates of the origin
    # @param [Hash] values a hash containing the required values
    def self.print_output_head(coordinates, values)
      puts "Printing interpolated region around (%.2f, %.2f) for data set %d" %
            [coordinates[:x], coordinates[:y], values[:index] + 1]
      puts "\n"
    end

    # prints the meta information consisting of dataset name and informations
    # of the different dimensions
    def self.print_meta_information
      puts "\nRegional interpolation with domain properties:"

      print_domain_information(@domain_x, "\nX")
      print_domain_information(@domain_y, 'Y')
    end

  end

end
