# @Author: Benjamin Held
# @Date:   2015-08-21 09:43:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-28 12:03:26

module TerminalVis

  module Output

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
      TerminalVis.data_repo.check_data_completeness(meta_data)
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

    # creates output when usind the option -d
    # @param [MetaData] meta_data the meta data of the data series which should
    #  be visualized
    def self.create_delta_output(meta_data)
      data_indices = determine_indices_for_delta

      first_data = TerminalVis.data_repo.repository[meta_data].
                               series[data_indices[0]]
      second_data = TerminalVis.data_repo.repository[meta_data].
                               series[data_indices[1]]

      check_data(first_data, data_indices[0])
      check_data(second_data, data_indices[1])

      result = DatasetStatistics.subtract_datasets(first_data, second_data)

      DataOutput.print_delta(result, meta_data, data_indices,
                 TerminalVis.parameter_handler.repository.parameters[:extreme])
    end

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
        message = " Error: at least one argument of -d is not a number"
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
      DataOutput.print_dataset(TerminalVis.data_repo.repository[meta_data],
             index, meta_data,
             TerminalVis.parameter_handler.repository.parameters[:extreme])
    end
    private_class_method :create_single_output_at_index

    # checks if the returned data exists, nil means data access outside the
    # boundaries of the data
    # @param [DataSet] data the determined dataset
    # @param [Integer] index the provided index
    def self.check_data(data, index)
      if (data == nil)
        raise IndexError, " Error: argument #{index} from -d is out of bounds"
      end
    end
    private_class_method :check_data

  end

end
