# @Author: Benjamin Held
# @Date:   2015-10-09 12:50:02
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-09 15:40:00

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
    if (!@options[symbol])
      raise ArgumentError,
            'Error (Configuration): the provided option does not exist.'
    end
  end

end
