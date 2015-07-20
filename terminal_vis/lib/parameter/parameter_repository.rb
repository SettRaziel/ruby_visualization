# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-20 12:33:06

# Parameter repository storing the valid parameter of the script
# @parameters => Hash of valid parameters and their values
# raises ArgumentError
class ParameterRepository
    attr_reader :parameters

    # raises ArgumentError if parameters occur after reading the filepath
    # raises ArgumentError for an invalid combination of script parameters
    def initialize(argv)
        @parameters = Hash.new()
        unflagged_arguments = [:file]
        has_read_file = false
        argv.each { |arg|
            if (has_read_file)
                raise ArgumentError, "Error: found parameters after filepath"
            end

            case arg
                when '-h', '--help'    then parameters[:help] = true
                when '-v', '--version' then parameters[:version] = true
                when '-m'              then parameters[:meta] = true
                when '-i'              then unflagged_arguments.unshift(:index)
                when '-a', '--all'     then parameters[:all] = true
                when /-[a-z]|--[a-z]+/ then raise_invalid_parameter(arg)
            else
                if (arg_key = unflagged_arguments.shift)
                    parameters[arg_key] = arg
                else
                    raise ArgumentError,
                            "Error: invalid combination of parameters."
                end
            end

            has_read_file = true if (unflagged_arguments.size == 0)
        }

        # check if all parameters have been handled correctly
        # only with -h and -v should be the :file element left
        if (unflagged_arguments.size > 0 &&
            !(@parameters[:help] || @parameters[:version]))
            raise ArgumentError, "Error: invalid combination of parameters."
        end
    end

    private

    # error message in the case of an invalid argument
    # raises Argument Error if an invalid argument is provided
    def raise_invalid_parameter(arg)
        raise ArgumentError, "Error: invalid argument: #{arg}"
    end
end
