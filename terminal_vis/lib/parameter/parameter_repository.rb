# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-01 15:14:24

# Parameter repository storing the valid parameter of the script
# @parameter => Hash of valid parameters and their values
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
                    STDERR.puts "Error: invalid combination of parameters."
                    exit(0)
                end
            end
        }

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

    # error message in the case of an invalid argument
    def print_invalid_parameter(arg)
        STDERR.puts "Error: invalid argument: #{arg}"
        exit(0)
    end
end
