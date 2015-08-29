# @Author: Benjamin Held
# @Date:   2015-07-20 11:23:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-29 10:45:39

require_relative 'parameter_repository'

# class to seperate the storage of the parameter in a repository entity and
# checking for valid parameter combination as part of the application logic.
# Can raise an {ArgumentError} or {IndexError} when invalid parameter arguments
# or parameter combinations are provided
class ParameterHandler
  # @return [ParameterRepository] repository which reads and stores the
  # parameter provided as arguments in script call
  attr_reader :repository

  # initialization
  # @param [Array] argv array of input parameters
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
    check_number_of_parameters(:time, 2)

    check_constraints_for_a if (repository.parameters[:all])
    check_constraints_for_c if (repository.parameters[:coord])
    check_constraints_for_d if (repository.parameters[:delta])
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
  #   !(-a + -t), !(-t + -a)
  #   !(-a + -d), !(-d + -a)
  # @raise [ArgumentError] if invalid parameter combination occurs
  def check_constraints_for_a
    create_constrain_error('-a', '-i') if (repository.parameters[:index])
    create_constrain_error('-a', '-t') if (repository.parameters[:time])
    create_constrain_error('-a', '-d') if (repository.parameters[:delta])
  end

  # checks constraints:
  #   !(-c + -e), !(-e + -c),
  #   !(-c + -t), !(-t + -c)
  # @raise [ArgumentError] if invalid parameter combination occurs
  def check_constraints_for_c
    create_constrain_error('-c', '-e') if (repository.parameters[:extreme])
    create_constrain_error('-c', '-t') if (repository.parameters[:time])
  end

  # checks contraints:
  #   !(-d + -i), !(-i + -d),
  #   !(-d + -t), !(-t + -d)
  # @raise [ArgumentError] if invalid parameter combination occurs
  def check_constraints_for_d
    create_constrain_error('-d', '-i') if (repository.parameters[:index])
    create_constrain_error('-d', '-t') if (repository.parameters[:time])
  end

  # creates a constraint error if an invalid parameter combination occurs
  # @param [String] v first parameter
  # @param [String] i second parameter
  # @raise [ArgumentError] for an invalid parameter combination
  def create_constrain_error(v, i)
    raise ArgumentError, " Error: invalid parameter combination: #{v} and #{i}"
  end

  # checks the correct number of parameters for the given key
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

end
