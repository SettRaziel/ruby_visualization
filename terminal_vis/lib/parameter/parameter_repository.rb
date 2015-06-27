# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-27 16:40:25

# Parameter repository storing the valid parameter of the script
# @parameter_regex => Hash of regular expressions of valid parameters
# @parameter_used => Hash of used parameters in script call
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
                # when '-i'              then unflagged_arguments.unshift(:index)
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

        check_for_valid_filepath()
    end

    def check_for_valid_filepath
        filepath = parameters[:file]
        file_regex= %r{
            \A                      # start of string
            ((\.\/)|(\.\.\/)+)      # relativ path or upwards
            ([\-\w\s]+\/)*          # 0-n subsirectories
            [\-\w\s]*[a-zA-Z0-9]    # filename
            (\.[a-zA-Z0-9]+)?       # extension
            \z                      # end of string
            }x

        if (!filepath =~ file_regex)
            STDERR.puts "Error: invalid filepath: #{filepath}"
            exit(0)
        end
    end

    def print_invalid_parameter(arg)
        STDERR.puts "Error: invalid argument: #{arg}"
        exit(0)
    end
end
