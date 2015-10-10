# @Author: Benjamin Held
# @Date:   2015-10-09 12:50:02
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-10 20:32:57

# Repository storing available configuration parameters. If no parameters are
# set from the user, the default values for the parameters are used.
class ConfigurationRepository
  # @return [Hash] Hash of parameters and their values
  attr_reader :options

  # initialization
  # @param [Hash] options a hash with new values for the parameters
  def initialize(options=nil)
    default_options
    process_options(options) if (options != nil)
  end

  # method to change the value of a specific symbol to a new value
  # @param [Symbol] symbol the provided symbol
  # @param [Object] value the provided value for the symbol
  def change_option(symbol, value)
    check_symbol_existance(symbol)
    check_value_class(symbol, value)

    @options[symbol] = value
  end

  private

  # method to initialize the attribute with the specified default values
  def default_options
    @options = Hash.new()
    @options[:legend_extend] = false # interval output for color legend
    @options[:y_time_size] = 20      # number of intervals in y for timeline
  end

  # method to overwrite the default values with the provided values
  # @param [Hash] options a hash with the new parameter values
  def process_options(options)
    @options.each_key { |key|
      @options[key] = options[key] if (options[key])
    }
  end

  # method to check if a given symbol exists in the options hash
  # @param [Symbol] symbol the provided symbol
  # @raise [ArgumentError] if the symbol does not occur in the options hash
  def check_symbol_existance(symbol)
    if (@options[symbol] == nil)
      raise ArgumentError,
            'Error (Configuration): the provided option does not exist.'
    end
  end

  # method to check if the provided value class is the same as the value
  # class set as the current value
  # @param [Symbol] symbol the provided symbol
  # @param [Object] value the provided value for the symbol
  def check_value_class(symbol, value)
    if (@options[symbol].class == TrueClass ||
           @options[symbol].class == FalseClass)
      check_boolean(value)
    elsif (@options[symbol].class != value.class)
      raise_type_error
    end
  end

  # method to check the special case for boolean parameters
  # @param [Object] value the provided value
  def check_boolean(value)
    if (!(value.class == TrueClass || value.class == FalseClass))
      raise_type_error
    end
  end

  # method to raise a Type error if the value check fails
  # @raise [TypeError] if the class of the now value does not fit the class
  #   of the old one
  def raise_type_error
      raise TypeError, 'Error (Configuration): the type of a new value does ' \
                       'not fit the original type.'
  end

end
