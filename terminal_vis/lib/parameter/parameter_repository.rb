# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-04 14:52:51

# Parameter repository storing the valid parameter of the script
# @parameters => Hash of valid parameters and their values
class ParameterRepository
    attr_reader :parameters

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

    # checks if the parsed filename is a valid unix or windows file name
    def check_for_valid_filepath
        filepath = parameters[:file]
        unixfile_regex= %r{
            \A                       # start of string
            ((\.\/)|(\.\.\/)+|(\/))? # relativ path or upwards or absolute
            ([\-\w\s]+\/)*           # 0-n subsirectories
            [\-\w\s]*[a-zA-Z0-9]     # filename
            (\.[a-zA-Z0-9]+)?        # extension
            \z                       # end of string
        }x

        windowsfile_regex = %r{
            \A                      # start of string
            ([A-Z]:)?\\?            # device name
            ([\-\w\s]+\\)*          # directories
            [\-\w\s]*[a-zA-Z0-9]    # filename
            (\.[a-zA-Z0-9]+)?       # extension
            \z                      # end of string
        }x

        if (!(filepath =~ unixfile_regex || filepath =~ windowsfile_regex))
            raise ArgumentError, "Error: invalid filepath: #{filepath}"
        end
    end

    private

    # error message in the case of an invalid argument
    def raise_invalid_parameter(arg)
        raise ArgumentError, "Error: invalid argument: #{arg}"
    end
end