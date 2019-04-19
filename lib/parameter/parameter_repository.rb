# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2019-04-19 17:14:13

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
        when '-a', '--all'
          create_argument_entry(:all, unflagged_arguments)
        when '-c', '--coord'
          create_two_argument_entry(:coord, unflagged_arguments)
        when '-d', '--delta'
          create_two_argument_entry(:delta, unflagged_arguments)
        when '-e', '--extreme' then @parameters[:extreme] = true
        when '-i'
          create_argument_entry(:index, unflagged_arguments)
        when '-m'              then @parameters[:meta] = true
        when '-o', '--options'
          create_argument_entry(:option, unflagged_arguments)
        when '-r', '--range'
          create_two_argument_entry(:range, unflagged_arguments)
        when '-s', '--section'
          create_two_argument_entry(:section, unflagged_arguments)
        when '-t', '--time'
          create_two_argument_entry(:time, unflagged_arguments)
        else
          raise_invalid_parameter(arg)
      end
    end

  end

end
