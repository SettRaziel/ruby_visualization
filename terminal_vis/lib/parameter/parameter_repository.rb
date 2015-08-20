# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-20 10:27:15

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

      case arg
        when '-h', '--help'    then check_and_set_helpvalue
        when '-v', '--version' then @parameters[:version] = true
        when '-a', '--all'
          @parameters[:all] = nil
          unflagged_arguments.unshift(:all)
        when '-c', '--coord'
          @parameters[:coord] = Array.new()
          2.times{ unflagged_arguments.unshift(:coord) }
        when '-d', '--delta'
          @parameters[:delta] = Array.new()
          2.times{ unflagged_arguments.unshift(:delta) }
        when '-e', '--extreme' then @parameters[:extreme] = true
        when '-i'
          @parameters[:index] = nil
          unflagged_arguments.unshift(:index)
        when '-m'              then @parameters[:meta] = true
        when /-[a-z]|--[a-z]+/ then raise_invalid_parameter(arg)
      else
        check_and_set_argument(unflagged_arguments.shift, arg)
      end

      has_read_file = true if (unflagged_arguments.size == 0)
    }

  check_parameter_handling(unflagged_arguments.size)
  end

  private

  # check if a parameter holds one or more arguments and adds the argument
  # depending on the check
  # @param [Symbol] unflagged_argument symbol referencing a parameter
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
        raise ArgumentError, "Error: found filepath: #{@parameters[:file]}, " \
                             "but there are other arguments left."
    end
  end

  # checks if all parameters have been handled correctly
  # only with -h and -v should be the :file element left
  # @param [Fixnum] size size of the argument array
  # @raise [ArgumentError] if parameter combination not valid
  def check_parameter_handling(size)
    if (size > 0 && !(@parameters[:help] || @parameters[:version]))
        raise ArgumentError, 'Error: invalid combination of parameters.'
    end
  end

  # error message in the case of an invalid argument
  # arg => invalid parameter string
  # raises Argument Error if an invalid argument is provided
  def raise_invalid_parameter(arg)
    raise ArgumentError, " Error: invalid argument: #{arg}"
  end

end
