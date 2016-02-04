# @Author: Benjamin Held
# @Date:   2015-11-19 16:16:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-04 15:18:09

module TerminalVis

  # This module holds methods who are collecting the required parameters for
  # a specific output format. They collect them from the corresponding
  # repositories and return them.
  module ParameterCollector

    # method to get the required values to generate timeline output
    # @return [Hash] a hash with the required values
    def self.determine_timeline_values
      values = retrieve_parameters(:x, :y, :time, 'Float')
      values[:y_size] = TerminalVis.option_handler.options.
                         repository[:y_time_size]
      return values
    end

    # method to get the required coordinates to start an interpolation
    def self.determine_interpolation_values
      retrieve_parameters(:x, :y, :coord, 'Float')
    end

    # gets the indices of the data sets which should be substracted
    # @return [Hash] the indices of the two datasets
    def self.determine_indices_for_delta
      data_indices = retrieve_parameters(:first, :second, :delta, 'Integer')
      data_indices[:first] -= 1
      data_indices[:second] -= 1
      return data_indices
    end

    # method to determine the required parameters for the paramater -r
    # @return [Hash] a hash with with required parameters
    def self.determine_range_parameters
      parameters = retrieve_parameters(:lower, :upper, :range, 'Integer')
      parameters[:lower] -= 1
      parameters[:upper] -= 1
      parameters[:all] = TerminalVis.parameter_handler.
                                     repository.parameters[:all]
      return parameters
    end

    # method to get the required values to create a region that will be
    # interpolated
    # @return [Hash] the values to determine the interpolation region
    def self.determine_region_parameters
      parameters = retrieve_parameters(:inter, :delta, :section, 'Float')
      { :inter => parameters[:inter], :delta_x => parameters[:delta],
        :delta_y => parameters[:delta]}
    end

    # method to retrive the parameters for the given type
    # @param [Symbol] first the first parameter argument
    # @param [Symbol] second the second parameter argument
    # @param [Symbol] parameter the requested parameter
    # @param [String] type the required type
    # @return [Hash] the hash with the required values
    def self.retrieve_parameters(first, second, parameter, type)
      begin
        case type
          when 'Integer'
            return retrieve_integer_parameters(first, second, parameter)
          when 'Float'
            return retrieve_float_parameters(first, second, parameter)
          else
            TerminalVis::print_error("Error: unknown parameter: #{type}")
        end
      rescue ArgumentError
        create_error_message(parameter, type)
      end
    end
    private_class_method :retrieve_parameters

    # method to retrive the parameters for interger values
    # @param [Symbol] first the first parameter argument
    # @param [Symbol] second the second parameter argument
    # @param [Symbol] parameter the requested parameter
    # @return [Hash] the hash with the required values
    def self.retrieve_integer_parameters(first, second, parameter)
      {first => Integer(read_parameter(parameter, 0)),
       second => Integer(read_parameter(parameter, 1))}
    end
    private_class_method :retrieve_integer_parameters

    # method to retrive the parameters for float values
    # @param [Symbol] first the first parameter argument
    # @param [Symbol] second the second parameter argument
    # @param [Symbol] parameter the requested parameter
    # @return [Hash] the hash with the required values
    def self.retrieve_float_parameters(first, second, parameter)
      {first => Float(read_parameter(parameter, 0)),
       second => Float(read_parameter(parameter, 1))}
    end
    private_class_method :retrieve_float_parameters

    # method to read the value for a given parameter and index
    # @param [Symbol] parameter the provided parameter
    # @param [Integer] index the given index
    # @return [String] the value stored for the parameter at index
    def self.read_parameter(parameter, index)
      TerminalVis.parameter_handler.repository.parameters[parameter][index]
    end
    private_class_method :read_parameter

    # method to create an error message when rescuing an error
    # @param [Symbol] parameter the requested parameter
    # @param [String] type a string containing the type for the error message
    def self.create_error_message(parameter, type)
      message = " Error: at least one argument of #{parameter}" \
                " is not a valid #{type}".red
      TerminalVis::print_error(message)
    end
    private_class_method :create_error_message

  end
end
