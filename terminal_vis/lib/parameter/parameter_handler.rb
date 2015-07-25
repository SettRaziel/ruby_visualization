# @Author: Benjamin Held
# @Date:   2015-07-20 11:23:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-25 12:31:03

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
        check_occurence_of_a_and_i()
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
            raise ArgumentError, "Error: invalid filepath: #{filepath}"
        end
    end

    # check if both parameters -a, --all and -i are given as parameters, which
    # are disjunct in their functionality
    # raises ArgumentError if both parameters are set
    def check_occurence_of_a_and_i
        if (repository.parameters[:all] && repository.parameters[:index])
            raise ArgumentError,
                             "Error: parameters -a and -i secludes themselves"
        end
    end

end
