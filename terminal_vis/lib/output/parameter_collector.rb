# @Author: Benjamin Held
# @Date:   2015-11-19 16:16:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-19 16:54:03

module TerminalVis

  # This module holds methods who are collecting the required parameters for
  # a specific output format. They collect them from the corresponding
  # repositories and return them.
  module ParameterCollector

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

    # method to get the required coordinates to start an interpolation
    def self.determine_interpolation_values
      coords = Hash.new()
      coords[:x] = Float(TerminalVis.parameter_handler.
                         repository.parameters[:coord][0])
      coords[:y] = Float(TerminalVis.parameter_handler.
                         repository.parameters[:coord][1])
      return coords
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
        message = " Error: at least one argument of -d is not a valid number"
        TerminalVis::print_error(message)
      end
      return data_indices
    end

    # method to determine the required parameters for the paramater -r
    # @return [Hash] a hash with with required parameters
    def self.determine_range_parameters
      parameters = Hash.new()
      parameters[:lower] = Integer(TerminalVis.parameter_handler.
                                repository.parameters[:range][0]) - 1
      parameters[:upper] = Integer(TerminalVis.parameter_handler.
                                repository.parameters[:range][1]) - 1
      if (TerminalVis.parameter_handler.repository.parameters[:all])
      parameters[:all] = TerminalVis.parameter_handler.
                         repository.parameters[:all]
      end
      return parameters
    end

  end
end
