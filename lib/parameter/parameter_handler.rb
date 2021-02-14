# @Author: Benjamin Held
# @Date:   2015-07-20 11:23:58
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2021-02-14 22:00:53

module Parameter

  # class to seperate the storage of the parameter in a repository entity and
  # checking for valid parameter combination as part of the application logic.
  # Can raise an ArgumentError or IndexError when invalid parameter arguments
  # or parameter combinations are provided
  class ParameterHandler < RubyUtils::Parameter::BaseParameterHandler

    # method to initialize the correct repository that should be used 
    # in this handler
    # @param [Array] argv array of input parameters
    def initialize_repository(argv)
      @repository = ParameterRepository.new(argv)
    end

    private

    # private method with calls of the different validations methods
    def validate_parameters
      check_for_valid_filepath if (@repository.parameters[:file])

      check_number_of_parameters(:coord, 2)
      check_number_of_parameters(:delta, 2)
      check_number_of_parameters(:time, 2)
      check_number_of_parameters(:range, 2)
      check_number_of_parameters(:section, 2)
    end

    # private method to the specified parameter constraints
    def check_parameter_constraints
      check_constraints_for_a if (@repository.parameters[:all])
      check_constraints_for_c if (@repository.parameters[:coord])
      check_constraints_for_d if (@repository.parameters[:delta])
      check_constraints_for_r if (@repository.parameters[:range])
    
      # check mandatory file parameter
      check_mandatory_parameter(:file)
    end

    # private method to check the occurrence of two parameters
    def check_parameter_occurrence
      if (@repository.parameters[:section] && !@repository.parameters[:help])
        check_occurrence('-s', '-c', :coord)
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
      check_constraint('-c', '-e', :extreme) if (!@repository.parameters[:section])
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
      if (@repository.parameters[symbol])
        raise ArgumentError,
              " Error: invalid parameter combination: #{v} and #{i}"
      end
    end

  end

end
