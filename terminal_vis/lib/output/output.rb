# @Author: Benjamin Held
# @Date:   2015-08-21 09:43:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-21 11:02:36

module TerminalVis

  module Output

    # creates output based on metadata and parameters
    def self.create_output(meta_data)
      if (TerminalVis.parameter_handler.repository.parameters[:all])
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
      else
        index = TerminalVis.get_and_check_index(meta_data)
        create_single_output_at_index(meta_data, index)
      end
      TerminalVis.data_repo.check_data_completeness(meta_data)
    end

    # creates output when usind the option -d
    def self.create_delta_output(meta_data)
      first = 0; second = 0
      begin
        first = Integer(TerminalVis.parameter_handler.
                                    repository.parameters[:delta][0])
        second = Integer(TerminalVis.parameter_handler.
                                     repository.parameters[:delta][1])
      rescue ArgumentError
        message = " Error: at least one argument of -d is not a number"
        print_error(message)
      end

      first_data = TerminalVis.data_repo.repository[meta_data].series[first]
      second_data = TerminalVis.data_repo.repository[meta_data].series[second]

      check_data(first_data)
      check_data(second_data)

      result = DatasetStatistics.subtract_datasets(first_data, second_data)

      DataOutput.print_delta(result, meta_data, [first, second],
                 TerminalVis.parameter_handler.repository.parameters[:extreme])
    end

     # creates default output or output with an index using -i
    def self.create_single_output_at_index(meta_data, index)
      DataOutput.print_dataset(TerminalVis.data_repo.repository[meta_data],
             index, meta_data,
             TerminalVis.parameter_handler.repository.parameters[:extreme])
    end
    private_class_method :create_single_output_at_index

    # checks if the returned data exists, nil means data access outside the
    # boundaries of the data
    def self.check_data(data)
      if (data == nil)
        raise IndexError, " Error: argument #{data} from -d is out of bounds"
      end
    end
    private_class_method :check_data

  end

end
