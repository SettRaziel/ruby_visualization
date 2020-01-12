# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2020-01-12 12:55:22

# Parent module which holdes the classes dealing with reading and validating
# the provided input parameters
module Parameter

  # Parameter repository to store the valid parameters of the script.
  # {#initialize} gets the provided parameters and fills a hash which
  # grants access to the provided parameters and arguments.
  class ParameterRepository < BaseParameterRepository

    private

    # method to read further argument and process it depending on its content
    # @param [String] arg the given argument
    # @param [Array] unflagged_arguments the argument array
    def process_argument(arg, unflagged_arguments)
      case arg
        when *@mapping[:all] then create_argument_entry(:all, unflagged_arguments)
        when *@mapping[:coord] then create_two_argument_entry(:coord, unflagged_arguments)
        when *@mapping[:delta] then create_two_argument_entry(:delta, unflagged_arguments)
        when *@mapping[:extreme] then @parameters[:extreme] = true
        when *@mapping[:index] then create_argument_entry(:index, unflagged_arguments)
        when *@mapping[:meta] then @parameters[:meta] = true
        when *@mapping[:option] then create_argument_entry(:option, unflagged_arguments)
        when *@mapping[:range] then create_two_argument_entry(:range, unflagged_arguments)
        when *@mapping[:section] then create_two_argument_entry(:section, unflagged_arguments)
        when *@mapping[:time] then create_two_argument_entry(:time, unflagged_arguments)
        else
          raise_invalid_parameter(arg)
      end
    end

    # method to define the input string values that will match a given paramter symbol
    def define_mapping
      @mapping[:all] = ['-a', '--all']
      @mapping[:coord] = ['-c', '--coord']
      @mapping[:delta] = ['-d', '--delta']
      @mapping[:extreme] = ['-e', '--extreme']
      @mapping[:index] = ['-i', '--index']
      @mapping[:meta] = ['-m', '--meta']
      @mapping[:option] = ['-o', '--options']
      @mapping[:range] = ['-r', '--range']
      @mapping[:section] = ['-s', '--section']
      @mapping[:time] = ['-t', '--time']      
    end

  end

end
