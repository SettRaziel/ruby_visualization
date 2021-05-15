module TerminalVis

  # Parent module which holdes the classes dealing with reading and validating
  # the provided input parameters
  module Parameter

    # Parameter repository to store the valid parameters of the script.
    # {#initialize} gets the provided parameters and fills a hash which
    # grants access to the provided parameters and arguments.
    class ParameterRepository < RubyUtils::Parameter::BaseParameterRepository

      private

      # method to read further argument and process it depending on its content
      # @param [String] arg the given argument
      # @param [Array] unflagged_arguments the argument array
      def process_argument(arg)
        case arg
          when *@mapping[:all] then create_argument_entry(:all)
          when *@mapping[:coord] then create_two_argument_entry(:coord)
          when *@mapping[:delta] then create_two_argument_entry(:delta)
          when *@mapping[:extreme] then @parameters[:extreme] = true
          when *@mapping[:index] then create_argument_entry(:index)
          when *@mapping[:meta] then @parameters[:meta] = true
          when *@mapping[:option] then create_argument_entry(:option)
          when *@mapping[:range] then create_two_argument_entry(:range)
          when *@mapping[:section] then create_two_argument_entry(:section)
          when *@mapping[:time] then create_two_argument_entry(:time)
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
        @mapping[:option] = ['-o', '--option']
        @mapping[:range] = ['-r', '--range']
        @mapping[:section] = ['-s', '--section']
        @mapping[:time] = ['-t', '--time']      
      end

    end

  end

end
