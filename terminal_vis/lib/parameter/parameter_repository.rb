# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-03 12:29:59

# Parameter repository storing the valid parameter of the script
# @parameters => Hash of valid parameters and their values
class ParameterRepository
    attr_reader :parameters

    def initialize(argv)
        @parameters = Hash.new()
        unflagged_arguments = [:file]
        argv.each { |arg|
            case arg
                when '-h', '--help'    then parameters[:help] = true
                when '-v', '--version' then parameters[:version] = true
                when '-m'              then parameters[:meta] = true
                when '-i'              then unflagged_arguments.unshift(:index)
                when /-[a-z]|--[a-z]+/ then print_invalid_parameter(arg)
            else
                if (arg_key = unflagged_arguments.shift)
                    parameters[arg_key] = arg
                else
                    print_error("Error: invalid combination of parameters.")
                end
            end
        }

        # check if all parameters have been handled correctly
        # only with -h and -v should be the :file element left
        if (unflagged_arguments.size > 0 &&
            !(@parameters[:help] || @parameters[:version]))
            print_error("Error: invalid combination of parameters.")
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
            STDERR.puts "Error: invalid filepath: #{filepath}"
            exit(0)
        end
    end

    private

    # error message in the case of an invalid argument
    def print_invalid_parameter(arg)
        print_error("Error: invalid argument: #{arg}")
    end

    # method for printing a given error message
    def print_error(message)
        STDERR.puts "#{message}"
        exit(0)
    end
end
