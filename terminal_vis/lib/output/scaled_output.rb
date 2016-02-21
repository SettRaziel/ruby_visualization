# @Author: Benjamin Held
# @Date:   2016-01-29 10:17:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-21 17:08:49

module DataOutput

  class ScaledOutput < DatasetOutput

    require_relative '../main/main_module'
    require_relative '../configuration/terminal_size'

    # method to print a given dataset scaled by the terminal size
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def self.print_dataset(data_set, meta_data, options)
      # read terminal size from options hash
      set_terminal_dimension
      prepare_attributes(data_set, meta_data, options)
      print_output_head(options[:index], meta_data)
      # call print_data of the the parent class
      print_data(options[:legend], @meta_data.domain_x, @meta_data.domain_y)
    end

    private
    # @return [Integer] the number of lines of the used terminal
    attr :lines
    # @return [Integer] the number of fields per row of the used terminal
    attr :columns

    # method to set the required attributes und create the scaled dataset
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @param [Hash] options hash with the relevant parameter values
    def self.prepare_attributes(data_set, meta_data, options)
      # create meta data and data set for the scaled output
      @meta_data = calculate_resolution_meta(meta_data)
      scaled_data_set = calculate_scaled_dataset(data_set, meta_data)

      @legend = ColorLegend::ColorData.new(scaled_data_set.min_value,
                                           scaled_data_set.max_value)
      set_attributes(scaled_data_set, options[:extreme_values])
    end

    # creates a headline before printing the data set based on the values
    # of the z dimension
    # @param [Integer] index the number of the dataset
    def self.print_output_head(index, meta_data)
      puts "\nPrinting autoscaled dataset for %.2f" %
            (meta_data.domain_z.lower + (index * meta_data.domain_z.step))
      puts "\n"
    end

    # method to retrieve the current dimension of the used terminal
    def self.set_terminal_dimension
      ts = TerminalSize::TerminalSize.new()
      @lines = ts.lines - 14
      @columns = ts.columns - 10
      check_value_boundaries
    end

    # method to create the meta data object for the scaled dataset
    # @param [MetaData] meta_data the corresponding meta data
    # @return [MetaData] the meta data of the scaled dataset
    def self.calculate_resolution_meta(meta_data)
      # determine new meta information and create ne meta object
      meta_string = [meta_data.name]
      meta_string.concat(create_new_data_dimensions(meta_data))
      meta_string.concat(add_domain_information(meta_data.domain_z,
                                                meta_data.domain_z.step))
      # return the new meta data object
      MetaData::MetaData.new(meta_string)
    end

    # method to create the entris for the x and y domain of the scaled meta data
    # @param [MetaData] meta_data the corresponding meta data
    # @return [Array] the meta informations for the x and y domain
    def self.create_new_data_dimensions(meta_data)
      # map the meta information to the resolution
      delta_x = ((meta_data.domain_x.upper - meta_data.domain_x.lower) /
                 @columns).round(3) * 2
      delta_y = ((meta_data.domain_y.upper - meta_data.domain_y.lower) /
                 @lines).round(3)
      meta_string = add_domain_information(meta_data.domain_x, delta_x)
      meta_string.concat(add_domain_information(meta_data.domain_y, delta_y))
    end

    # method to check if the dimensions of the terminal are big enough to
    # create a useful result
    def self.check_value_boundaries
      if (@lines < 9 || @columns < 20)
        raise ArgumentError,
              ' Error: The terminal size is to small for scaled output'.red
      end
    end

    # method to add the required parameter to the meta data string
    # @return [Array] an array containing the string values for the given domain
    def self.add_domain_information(data_domain, new_step)
      [data_domain.name, data_domain.lower, data_domain.upper, new_step]
    end

    # method to create the scaled dataset by interpolating new data values
    # @param [DataSet] data_set the data set which should be visualized
    # @param [MetaData] meta_data the corresponding meta data
    # @return [Dataset] the scaled dataset
    def self.calculate_scaled_dataset(data_set, meta_data)
      coordinates = determine_coordinates
      values = determine_values

      TerminalVis::Interpolation.region_interpolation(meta_data,
                                 data_set, coordinates, values)
    end

    # method to retrieve the central coordinate of the dataset
    # @return [Hash] a hash with the x and y coordinate
    def self.determine_coordinates
      coordinates = Hash.new()
      coordinates[:x] = @meta_data.domain_x.lower +
                        calculated_dimension_delta(@meta_data.domain_x)
      coordinates[:y] = @meta_data.domain_y.lower +
                        calculated_dimension_delta(@meta_data.domain_y)
      return coordinates
    end

    # method to calculate the required parameter values for the interpolation
    # @return [Hash] a hash with the required parameters
    def self.determine_values
      { :inter_x => calculated_dimension_delta(@meta_data.domain_x),
        :delta_x => @meta_data.domain_x.step,
        :inter_y => calculated_dimension_delta(@meta_data.domain_y),
        :delta_y => @meta_data.domain_y.step }
    end

    # method to calculate the half distance of a data domain
    # @return [Float] the middle distance of the given data domain
    def self.calculated_dimension_delta(data_domain)
      ((data_domain.upper - data_domain.lower) / 2).round(3)
    end

  end

end
