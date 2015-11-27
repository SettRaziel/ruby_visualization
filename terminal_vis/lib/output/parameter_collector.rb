# @Author: Benjamin Held
# @Date:   2015-11-19 16:16:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-27 08:30:56

module TerminalVis

  # This module holds methods who are collecting the required parameters for
  # a specific output format. They collect them from the corresponding
  # repositories and return them.
  module ParameterCollector

    # method to get the required values to generate timeline output
    # @return [Hash] a hash with the required values
    def self.determine_timeline_values
      values = retrieve_float_parameters(:x, :y, :time)
      values[:y_size] = TerminalVis.option_handler.options.
                         repository[:y_time_size]
      return values
    end

    # method to get the required coordinates to start an interpolation
    def self.determine_interpolation_values
      retrieve_float_parameters(:x, :y, :coord)
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
      integers = Hash.new()
      begin
        integers[first] = Integer(TerminalVis.parameter_handler.
                                    repository.parameters[parameter][0])
        integers[second] = Integer(TerminalVis.parameter_handler.
                                     repository.parameters[parameter][1])
      rescue ArgumentError
        create_error_message(parameter, "Integer")
      end
      return integers
    end
    private_class_method :retrieve_integer_parameters

    # method to retrive the parameters for interger values
    # @param [Symbol] first the first parameter argument
    # @param [Symbol] second the second parameter argument
    # @param [Symbol] parameter the requested parameter
    def self.retrieve_float_parameters(first, second, parameter)
      floats = Hash.new()
      begin
        floats[first] = Float(TerminalVis.parameter_handler.
                                    repository.parameters[parameter][0])
        floats[second] = Float(TerminalVis.parameter_handler.
                                     repository.parameters[parameter][1])
      rescue ArgumentError
        create_error_message(parameter, "Float")
      end
      return floats
    end
    private_class_method :retrieve_float_parameters

    # method to create an error message when rescuing an error
    # @param [Symbol] parameter the requested parameter
    # @param [String] type a string containing the type for the error message
    def self.create_error_message(parameter, type)
      message = " Error: at least one argument of #{parameter}" \
                " is not a valid #{type}"
        TerminalVis::print_error(message)
    end
    private_class_method :create_error_message

  end
end
