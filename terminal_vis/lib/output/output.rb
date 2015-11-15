# @Author: Benjamin Held
# @Date:   2015-08-21 09:43:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-15 11:54:24

module TerminalVis

  # This module takes care about the output in the terminal and serves several
  # methods to create the desired output:
  #   * visual output
  #   * help output
  module Output

    require_relative 'interpolation_output'

    # creates output based on metadata and parameters
    # @param [MetaData] meta_data the meta data of the data series which should
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
    # @param [MetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_animation(meta_data)
      data_series = TerminalVis.data_repo.repository[meta_data]
      animation_speed = Integer(TerminalVis.parameter_handler.
                                            repository.parameters[:all])
      data_series.series.each_index { |index|
          create_single_output_at_index(meta_data, index)
          if (animation_speed > 0)
            sleep(animation_speed)
          else
            print 'press Enter to continue ...'
            # STDIN to read from console when providing parameters in ARGV
            STDIN.gets.chomp
          end
      }
    end
    private_class_method :create_animation

    # creates output when using the parameter -d
    # @param [MetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_delta_output(meta_data)
      data_indices = determine_indices_for_delta
      data = get_data_for_indices(data_indices, meta_data)

      result = DatasetStatistics.subtract_datasets(data[:first_data],
                                                   data[:second_data])

      options = get_output_options
      DataOutput.print_delta(result, meta_data, data_indices, options)
    end

    # creates output when using the parameter -c
    # @param [MetaData] meta_data the meta data of the data series where the
    # interpolation should be applied
    def self.create_interpolation_output(meta_data)
      coordinates = determine_interpolation_values
      index = TerminalVis.get_and_check_index(meta_data)
      data_set = get_and_check_data(index, meta_data)
      value = TerminalVis::Interpolation.
              interpolate_for_coordinate(meta_data, coordinates, data_set)
      InterpolationOutput.interpolation_output(value, index, coordinates,
                                               data_set)
    end

    # creates output when using the parameter -r
    # @param [MetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_range_output(meta_data)
      data_series = TerminalVis.data_repo.repository[meta_data]

      options = get_output_options
      RangeOutput.print_ranged_data(meta_data, data_series,
                                    TerminalVis.parameter_handler.repository,
                                    options)
    end

    # creates a time line for the parameter -t
    # @param [MetaData] meta_data the meta data of the data series from which
    #  the timeline should be created
    def self.create_timeline(meta_data)
      data_series = TerminalVis.data_repo.repository[meta_data]
      values = determine_timeline_values
      timeline = Timeline.create_timeline(meta_data, data_series,
                 values[:x], values[:y], values[:y_size])
      TimelineOutput.print_timeline(timeline, meta_data, values[:x], values[:y])
    end

    # method to get the required values to generate timeline output
    # @return [Hash] a hash with the required values
    def self.determine_timeline_values
      values = Hash.new()
      values[:x] = Float(TerminalVis.parameter_handler.
                         repository.parameters[:time][0])
      values[:y] = Float(TerminalVis.parameter_handler.
                         repository.parameters[:time][1])
      values[:y_size] = TerminalVis.option_handler.options.
                         repository[:y_time_size]
      return values
    end
    private_class_method :determine_timeline_values

    # method to get the required coordinates to start an interpolation
    def self.determine_interpolation_values
      coords = Hash.new()
      coords[:x] = Float(TerminalVis.parameter_handler.
                         repository.parameters[:coord][0])
      coords[:y] = Float(TerminalVis.parameter_handler.
                         repository.parameters[:coord][1])
      return coords
    end
    private_class_method :determine_interpolation_values

    # gets the indices of the data sets which should be substracted
    # @return [Array] the indices of the two datasets
    def self.determine_indices_for_delta
      data_indices = Array.new(2)
      begin
        data_indices[0] = Integer(TerminalVis.parameter_handler.
                                    repository.parameters[:delta][0])
        data_indices[1] = Integer(TerminalVis.parameter_handler.
                                     repository.parameters[:delta][1])
      rescue ArgumentError
        message = " Error: at least one argument of -d is not a valid number"
        TerminalVis::print_error(message)
      end
      return data_indices
    end
    private_class_method :determine_indices_for_delta

    # creates default output or output with an index using -i
    # @param [MetaData] meta_data the meta data of the data series which should
    #  be visualized
    # @param [Integer] index the index of the dataset which should be visualized
    def self.create_single_output_at_index(meta_data, index)
      options = get_output_options
      DataOutput.print_dataset(TerminalVis.data_repo.repository[meta_data],
             index, meta_data, options)
    end
    private_class_method :create_single_output_at_index

    # method to determine output options for the extreme values and the
    # extended legend
    # @return [Hash] the hash with the boolean parameters for the options
    def self.get_output_options
      options = Hash.new()
      options[:extreme_values] = TerminalVis.parameter_handler.repository.
                                 parameters[:extreme]
      options[:legend] = TerminalVis.option_handler.options.
                         repository[:legend_extend]
      return options
    end
    private_class_method :get_output_options

    # method to check the datasets specified by the data indices and return
    # the data
    # @param [Array] data_indices the indices of the required datasets
    # @param [MetaData] meta_data the corresponding meta data
    # @return [Hash] a hash containing the selected datasets
    def self.get_data_for_indices(data_indices, meta_data)
      data = Hash.new()
      data[:first_data] = get_and_check_data(data_indices[0], meta_data)
      data[:second_data] = get_and_check_data(data_indices[1], meta_data)
      return data
    end
    private_class_method :get_data_for_indices


    # checks if the returned data exists, nil means data access outside the
    # boundaries of the data
    # @param [Integer] index the provided index
    # @param [MetaData] meta_data the corresponding meta data
    # @return [DataSet] the dataset for the given index and meta data
    # @raise [IndexError] if no data was selected which means the index is not
    #  within the bounds of the provided meta data
    def self.get_and_check_data(index, meta_data)
      data = TerminalVis.data_repo.repository[meta_data].series[index]
      if (data == nil)
        raise IndexError, " Error: argument #{index} from -d is out of bounds"
      end
      return data
    end
    private_class_method :get_and_check_data

  end

end
