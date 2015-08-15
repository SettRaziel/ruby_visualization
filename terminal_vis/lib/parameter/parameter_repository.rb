# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-12 19:47:28

# Parameter repository storing the valid parameter of the script
# @parameters => Hash of valid parameters and their values
# raises ArgumentError
class ParameterRepository
    attr_reader :parameters

    # initialize
    # argv => Array of input parameters
    # raises ArgumentError if parameters occur after reading the filepath
    # raises ArgumentError for an invalid combination of script parameters
    def initialize(argv)
        @parameters = Hash.new()
        unflagged_arguments = [:file]
        has_read_file = false
        argv.each { |arg|
            if (has_read_file)
                raise ArgumentError, "Error: found filepath: " \
                                     "#{@parameters[:file]}, but there are " \
                                     "other arguments left."
            end

            case arg
                when '-h', '--help'
                    if(@parameters.keys.last != nil)
                        # help in context to a parameter
                        @parameters[:help] = @parameters.keys.last
                    else
                        # help without parameter => global help
                        @parameters[:help] = true
                    end
                when '-v', '--version' then @parameters[:version] = true
                when '-a', '--all'     then @parameters[:all] = true
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
                if (arg_key = unflagged_arguments.shift)
                    if(@parameters[arg_key] != nil)
                        @parameters[arg_key] << arg
                    else
                        @parameters[arg_key] = arg
                    end
                else
                    raise ArgumentError,
                            ' Error: invalid combination of parameters.'
                end
            end

            has_read_file = true if (unflagged_arguments.size == 0)
        }

        # check if all parameters have been handled correctly
        # only with -h and -v should be the :file element left
        if (unflagged_arguments.size > 0 &&
            !(@parameters[:help] || @parameters[:version]))
            raise ArgumentError, 'Error: invalid combination of parameters.'
        end
    end

    private

    # error message in the case of an invalid argument
    # arg => invalid parameter string
    # raises Argument Error if an invalid argument is provided
    def raise_invalid_parameter(arg)
        raise ArgumentError, " Error: invalid argument: #{arg}"
    end

end
