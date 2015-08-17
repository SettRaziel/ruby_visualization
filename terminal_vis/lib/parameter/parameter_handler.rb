# @Author: Benjamin Held
# @Date:   2015-07-20 11:23:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-17 11:17:28

require_relative 'parameter_repository'

# class to seperate the storage of the parameter in a repository entity and
# checking for valid parameter combination as part of the application logic
# @repository => parameter repository which reads and stores the parameter
# provided as arguments in script call
# raises ArgumentError
class ParameterHandler
    attr_reader :repository

    # initialize
    # argv => Array of input parameters
    def initialize(argv)
        @repository = ParameterRepository.new(argv)
        validate_parameters()
    end

    private

    # private method with calls of the different validations methods
    def validate_parameters
        check_for_valid_filepath() if (repository.parameters[:file])

        check_number_of_parameters(:coord, 2)
        check_number_of_parameters(:delta, 2)

        check_occurence_of_a_and_i()
        check_constraint_for_d()
    end

    # checks if the parsed filename is a valid unix or windows file name
    # raises ArgumentError if filepath is not valid
    def check_for_valid_filepath
        filepath = repository.parameters[:file]
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
            raise ArgumentError, " Error: invalid filepath: #{filepath}"
        end
    end

    # check if both parameters -a, --all and -i are given as parameters, which
    # are disjunct in their functionality
    # raises ArgumentError if both parameters are set
    def check_occurence_of_a_and_i
        if (repository.parameters[:all] && repository.parameters[:index])
            raise ArgumentError,
                             ' Error: parameters -a and -i secludes themselves'
        end
    end

    # checks contraints: -d excludes -a and -d excludes -i
    def check_constraint_for_d
        if (repository.parameters[:all] && repository.parameters[:delta])
            raise ArgumentError,
                             ' Error: parameters -d and -a secludes themselves'
        end
        if (repository.parameters[:index] && repository.parameters[:delta])
            raise ArgumentError,
                             ' Error: parameters -d and -i secludes themselves'
        end
    end

    # checks the correct number of parameters for the given key
    def check_number_of_parameters(key, count_parameters)
        if (repository.parameters[key] && !repository.parameters[:help])
            value = repository.parameters[key]
            if (value.size != count_parameters)
                raise IndexError,
                    " Error: invalid number of parameters for option: #{key} "
            end
        end
    end

end
