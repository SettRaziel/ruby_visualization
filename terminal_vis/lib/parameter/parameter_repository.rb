# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-23 09:26:52

# Parameter repository storing the valid parameter of the script.
# {#initialize} gets the provided parameters and fills a hash which
# grants access on the provided parameters and their arguments
class ParameterRepository
  # @return [Hash] Hash of valid parameters and their values
  attr_reader :parameters

  # initialization
  # @param [Array] argv Array of input parameters
  # @raise [ArgumentError] if parameters occur after reading the filepath
  # @raise [ArgumentError] for an invalid combination of script parameters
  def initialize(argv)
    @parameters = Hash.new()
    unflagged_arguments = [:file]
    has_read_file = false
    argv.each { |arg|
      has_read_file?(has_read_file)

      has_read_file =  process_argument(arg, unflagged_arguments)
    }

  check_parameter_handling(unflagged_arguments.size)
  end

  private

  # method to read the given argument and process it depending on its content
  # @param [String] arg the given argument
  # @param [Array] unflagged_arguments the argument array
  # @return [boolean] if the size of the argument array is zero or not
  def process_argument(arg, unflagged_arguments)
    case arg
      when '-h', '--help'    then check_and_set_helpvalue
      when '-v', '--version' then @parameters[:version] = true
      when '-a', '--all'
        create_argument_entry(:all, unflagged_arguments)
      when '-c', '--coord'
        create_two_argument_entry(:coord, unflagged_arguments)
      when '-d', '--delta'
        create_two_argument_entry(:delta, unflagged_arguments)
      when '-e', '--extreme' then @parameters[:extreme] = true
      when '-i'
        create_argument_entry(:index, unflagged_arguments)
      when '-m'              then @parameters[:meta] = true
      when '-o', '--options'
        create_argument_entry(:option, unflagged_arguments)
      when '-r', '--range'
        create_two_argument_entry(:range, unflagged_arguments)
      when '-s', '--section'
        create_two_argument_entry(:section, unflagged_arguments)
      when '-t', '--time'
        create_two_argument_entry(:time, unflagged_arguments)
      when /-[a-z]|--[a-z]+/ then raise_invalid_parameter(arg)
    else
      check_and_set_argument(unflagged_arguments.shift, arg)
    end

    return (unflagged_arguments.size == 0)

  end

  # creates a new entry for a parameter with one argument
  # @param [Symbol] symbol the symbol of the argument
  # @param [Array] unflagged_arguments the argument array
  def create_argument_entry(symbol, unflagged_arguments)
    @parameters[symbol] = nil
    unflagged_arguments.unshift(symbol)
  end

  # creates a new entry for a parameter with two arguments
  # @param [Symbol] symbol the symbol of the argument
  # @param [Array] unflagged_arguments the argument array
  def create_two_argument_entry(symbol, unflagged_arguments)
    @parameters[symbol] = Array.new()
    2.times{ unflagged_arguments.unshift(symbol) }
  end

  # check if a parameter holds one or more arguments and adds the argument
  # depending on the check
  # @param [Symbol] arg_key the symbol referencing a parameter
  # @param [String] arg the argument from the input array
  def check_and_set_argument(arg_key, arg)
    if (arg_key != nil)
      if(@parameters[arg_key] != nil)
        @parameters[arg_key] << arg
      else
        @parameters[arg_key] = arg
      end
    else
      raise ArgumentError, ' Error: invalid combination of parameters.'
    end
  end

  # checks if the help parameter was entered with a parameter of if the
  # general help information is requested
  def check_and_set_helpvalue
    if(@parameters.keys.last != nil)
      # help in context to a parameter
      @parameters[:help] = @parameters.keys.last
    else
      # help without parameter => global help
      @parameters[:help] = true
    end
  end

  # checks if the filename has already been read
  # @param [boolean] read_file boolean which is true, when the filename has
  #  already been read; false, if not.
  # @raise [ArgumentError] if the file has read and other parameter are still
  #  following
  def has_read_file?(read_file)
    if (read_file)
        raise ArgumentError, " Error: found filepath: #{@parameters[:file]}," \
                             " but there are other arguments left."
    end
  end

  # checks if all parameters have been handled correctly
  # only with -h and -v should be the :file element left
  # @param [Fixnum] size size of the argument array
  # @raise [ArgumentError] if parameter combination not valid
  def check_parameter_handling(size)
    if (size > 0 && !(@parameters[:help] || @parameters[:version]))
        raise ArgumentError, ' Error: invalid combination of parameters.'
    end
  end

  # error message in the case of an invalid argument
  # @param [String] arg invalid parameter string
  # @raise [ArgumentError] if an invalid argument is provided
  def raise_invalid_parameter(arg)
    raise ArgumentError, " Error: invalid argument: #{arg}"
  end

end
