# @Author: Benjamin Held
# @Date:   2015-11-19 16:16:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-24 13:52:07

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
    # @return [Hash] the indices of the two datasets
    def self.determine_indices_for_delta
      data_indices = retrieve_integer_parameters(:first, :second, :delta)
      data_indices[:first] -= 1
      data_indices[:second] -= 1
      return data_indices
    end

    # method to determine the required parameters for the paramater -r
    # @return [Hash] a hash with with required parameters
    def self.determine_range_parameters
      parameters = retrieve_integer_parameters(:lower, :upper, :range)
      parameters[:lower] -= 1
      parameters[:upper] -= 1
      parameters[:all] = TerminalVis.parameter_handler.
                                     repository.parameters[:all]
      return parameters
    end

    # method to retrive the parameters for interger values
    # @param [Symbol] first the first parameter argument
    # @param [Symbol] second the second parameter argument
    # @param [Symbol] parameter the requested parameter
    def self.retrieve_integer_parameters(first, second, parameter)
      parameters = Hash.new()
      begin
        parameters[first] = Integer(TerminalVis.parameter_handler.
                                    repository.parameters[parameter][0])
        parameters[second] = Integer(TerminalVis.parameter_handler.
                                     repository.parameters[parameter][1])
      rescue ArgumentError
        message = " Error: at least one argument of #{parameter}" \
                  " is not a valid Integer"
        TerminalVis::print_error(message)
      end
      return parameters
    end
    private_class_method :retrieve_integer_parameters

  end
end
