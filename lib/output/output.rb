module TerminalVis

  # This module takes care about the output in the terminal and serves several
  # methods to create the desired output:
  #   * visual output
  #   * help output
  module Output

    require_relative "./data_output/data_output"
    require_relative "interpolation_output"
    require_relative "range_output"
    require_relative "timeline_output"
    require_relative "../math/time_line"
    require_relative "../scaling/timeline_scaling"
    require_relative "../math/dataset_statistics"

    # creates output based on {MetaData::VisMetaData} and parameters
    # @param [VisMetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_output(meta_data)
      if (TerminalVis.parameter_handler.repository.parameters[:all])
        create_animation(meta_data)
      else
        index = TerminalVis.get_and_check_index(meta_data)
        create_single_output_at_index(meta_data, index)
      end
      TerminalVis.data_repo.data_complete?(meta_data)
    end

    # creates animated output of the whole data series depending on the
    # animation parameter
    # @param [VisMetaData] meta_data the meta data of the data series which should
    #  be visualized
    private_class_method def self.create_animation(meta_data)
      data_series = TerminalVis.data_repo.repository[meta_data]
      animation_speed = Integer(TerminalVis.parameter_handler.
                                            repository.parameters[:all])
      data_series.series.each_index { |index|
          create_single_output_at_index(meta_data, index)
          if (animation_speed > 0)
            sleep(animation_speed)
          else
            print "press Enter to continue ...".green
            # STDIN to read from console when providing parameters in ARGV
            STDIN.gets.chomp
          end
      }
    end

    # creates output when using the parameter -d
    # @param [VisMetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_delta_output(meta_data)
      data_indices = ParameterCollector::determine_indices_for_delta
      data = get_data_for_indices(data_indices, meta_data)

      result = DatasetStatistics.subtract_datasets(data[:first_data],
                                                   data[:second_data])

      options = get_output_options
      if (!options[:auto_scale])
        DataOutput::DeltaOutput.new(result, meta_data, data_indices, options)
      else
        DataOutput::ScaledDeltaOutput.new(result, meta_data, data_indices,
                                          options)
      end
    end

    # creates output when using the parameter -c
    # @param [VisMetaData] meta_data the meta data of the data series where the
    # interpolation should be applied
    def self.create_interpolation_output(meta_data)
      coordinates = ParameterCollector::determine_interpolation_values
      index = TerminalVis.get_and_check_index(meta_data)
      value = TerminalVis::Interpolation.
              interpolate_for_coordinate(meta_data, coordinates,
                                         get_and_check_data(index, meta_data))
      InterpolationOutput.new(value, index, coordinates,
                          TerminalVis.data_repo.repository[meta_data])
    end

    # creates output when using the parameter -s
    # @param [VisMetaData] meta_data the meta data of the data series which should
    #   be used for the interpolation
    def self.create_region_interpolation_output(meta_data)
      coordinates = ParameterCollector::determine_interpolation_values
      values = ParameterCollector::determine_region_parameters
      values[:index] = TerminalVis.get_and_check_index(meta_data)
      values = values.merge(get_output_options)
      output = TerminalVis::Interpolation.region_interpolation(meta_data,
                            get_and_check_data(values[:index], meta_data),
                            coordinates, values)
      DataOutput::RegionOutput.new(output, coordinates,
                  TerminalVis.data_repo.repository[meta_data], values)
    end

    # creates output when using the parameter -r
    # @param [VisMetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_range_output(meta_data)
      data_series = TerminalVis.data_repo.repository[meta_data]
      parameters = ParameterCollector::determine_range_parameters

      options = get_output_options
      RangeOutput.new(meta_data, data_series, parameters, options)
    end

    # creates a time line for the parameter -t
    # @param [VisMetaData] meta_data the meta data of the data series from which
    #  the timeline should be created
    def self.create_timeline(meta_data)
      data_series = TerminalVis.data_repo.repository[meta_data]
      values = ParameterCollector::determine_timeline_values
      options = get_output_options
      if (!options[:auto_scale])
        timeline = Timeline.new(meta_data, data_series, values)
      else
        timeline = TimelineScaling.new(meta_data, data_series, values)
        meta_data = timeline.scaled_meta
      end
      TimelineOutput.new(timeline.mapped_values, meta_data, values)
    end

    # creates default output or output with an index using -i
    # @param [VisMetaData] meta_data the meta data of the data series which should
    #  be visualized
    # @param [Integer] index the index of the dataset which should be visualized
    private_class_method def self.create_single_output_at_index(meta_data, index)
      options = get_output_options
      options[:index] = index
      data_series = TerminalVis.data_repo.repository[meta_data]
      if (!options[:auto_scale])
        DataOutput::SingleOutput.new(data_series, meta_data, options)
      else
        DataOutput::ScaledDatasetOutput.new(data_series, meta_data, options)
      end
    end

    # method to determine output options for the extreme values and the
    # extended legend
    # @return [Hash] the hash with the boolean parameters for the options
    private_class_method def self.get_output_options
      { :extreme_values =>
        TerminalVis.parameter_handler.repository.parameters[:extreme],
        :legend =>
        TerminalVis.option_handler.options.repository[:legend_extend],
        :auto_scale =>
        TerminalVis::option_handler.options.repository[:auto_scale] }
    end

    # method to check the datasets specified by the data indices and return
    # the data
    # @param [Hash] data_indices the indices of the required datasets
    # @param [VisMetaData] meta_data the corresponding meta data
    # @return [Hash] a hash containing the selected datasets
    private_class_method def self.get_data_for_indices(data_indices, meta_data)
      data = Hash.new()
      check_data_range(data_indices)
      data[:first_data] = get_and_check_data(data_indices[:first], meta_data)
      data[:second_data] = get_and_check_data(data_indices[:second], meta_data)
      return data
    end

    # checks if the first argument of -d is less than 1
    # @param [Hash] data_indices the indices of the required datasets
    def self.check_data_range(data_indices)
      if (data_indices[:first] < 0)
        raise IndexError, " Error: first index of -d is less than 1".red
      end
    end

    # checks if the returned data exists, nil means data access outside the
    # boundaries of the data
    # @param [Integer] index the provided index
    # @param [VisMetaData] meta_data the corresponding meta data
    # @return [DataSet] the dataset for the given index and meta data
    # @raise [IndexError] if no data was selected which means the index is not
    #  within the bounds of the provided meta data
    private_class_method def self.get_and_check_data(index, meta_data)
      data = TerminalVis.data_repo.repository[meta_data].series[index]
      if (data == nil)
        raise IndexError, " Error: argument #{index + 1} from -d is out of bounds".red
      end
      return data
    end

  end

end
