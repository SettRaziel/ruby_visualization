# @Author: Benjamin Held
# @Date:   2015-07-20 11:23:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-04-18 18:05:02

module Parameter

  # class to seperate the storage of the parameter in a repository entity and
  # checking for valid parameter combination as part of the application logic.
  # Can raise an ArgumentError or IndexError when invalid parameter arguments
  # or parameter combinations are provided
  class ParameterHandler
    # @return [ParameterRepository] repository which reads and stores the
    # parameter provided as arguments in script call
    attr_reader :repository

    # initialization
    # @param [Array] argv array of input parameters
    def initialize(argv)
      @repository = ParameterRepository.new(argv)
      validate_parameters
      check_parameter_constraints
      check_parameter_occurrence
    end

    private

    # private method with calls of the different validations methods
    def validate_parameters
      check_for_valid_filepath if (repository.parameters[:file])

      check_number_of_parameters(:coord, 2)
      check_number_of_parameters(:delta, 2)
      check_number_of_parameters(:time, 2)
      check_number_of_parameters(:range, 2)
      check_number_of_parameters(:section, 2)
    end

    # private method to the specified parameter constraints
    def check_parameter_constraints
      check_constraints_for_a if (repository.parameters[:all])
      check_constraints_for_c if (repository.parameters[:coord])
      check_constraints_for_d if (repository.parameters[:delta])
      check_constraints_for_r if (repository.parameters[:range])
    end

    # private method to check the occurrence of two parameters
    def check_parameter_occurrence
      if (repository.parameters[:section] && !repository.parameters[:help])
        check_occurrence('-s', '-c', :coord)
      end
    end

    # checks if the parsed filename is a valid unix or windows file name
    # @raise [ArgumentError] if filepath is not valid
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

    # checks constraints:
    #   !(-a + -i), !(-i + -a),
    #   !(-a + -t), !(-t + -a),
    #   !(-a + -d), !(-d + -a)
    # @raise [ArgumentError] if invalid parameter combination occurs
    def check_constraints_for_a
      check_constraint('-a', '-i', :index)
      check_constraint('-a', '-d', :delta)
      check_constraint('-a', '-t', :time)
    end

    # checks constraints:
    #   !(-c + -e), !(-e + -c),
    #   !(-c + -t), !(-t + -c)
    # @raise [ArgumentError] if invalid parameter combination occurs
    def check_constraints_for_c
      check_constraint('-c', '-e', :extreme) if (!repository.parameters[:section])
      check_constraint('-c', '-t', :time)
    end

    # checks contraints:
    #   !(-d + -i), !(-i + -d),
    #   !(-d + -t), !(-t + -d)
    # @raise [ArgumentError] if invalid parameter combination occurs
    def check_constraints_for_d
      check_constraint('-d', '-i', :index)
      check_constraint('-d', '-t', :time)
    end

    # checks constraints:
    #   !(-r + -t), !(-t + -r),
    #   !(-r + -i), !(-i + -r)
    def check_constraints_for_r
      check_constraint('-r', '-t', :time)
      check_constraint('-r', '-i', :index)
    end

    # creates a constraint error if an invalid parameter combination occurs
    # @param [String] v the first parameter
    # @param [String] i the second parameter
    # @param [Symbol] symbol the literal to check
    # @raise [ArgumentError] for an invalid parameter combination
    def check_constraint(v, i, symbol)
      if (repository.parameters[symbol])
        raise ArgumentError,
              " Error: invalid parameter combination: #{v} and #{i}"
      end
    end

    # checks the correct number of parameters for the given key
    # @param [Symbol] key the key of a parameter
    # @param [Integer] count_parameters the number of arguments for this
    #  parameter
    # @raise [IndexError] if the number of arguments for the parameter is invalid
    def check_number_of_parameters(key, count_parameters)
      if (repository.parameters[key] && !repository.parameters[:help])
        value = repository.parameters[key]
        if (value.size != count_parameters)
          raise IndexError,
            " Error: invalid number of parameters for option: #{key} "
        end
      end
    end

    # checks if the second parameter occurs together with the first
    # @param [String] p the present parameter
    # @param [String] r the required parameter
    # @param [Symbol] symbol the literal to check
    # @raise [ArgumentError] if the second parameter is not present
    def check_occurrence(p, r, symbol)
      if (!repository.parameters[symbol])
        raise ArgumentError,
              " Error: #{p} requires the parameters of #{r}"
      end
    end

  end

end
