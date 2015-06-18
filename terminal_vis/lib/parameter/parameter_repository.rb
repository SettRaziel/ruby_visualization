# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-18 17:11:01

# Parameter repository storing the valid parameter of the script
# @parameter_regex => Hash of regular expressions of valid parameters
class ParameterRepository
    attr_reader :parameter_regex

    def initialize
        @parameter_regex = Hash.new()
        @parameter_regex["--help"] = /--help/   # help parameter
        @parameter_regex["-m"] = /-m/           # meta data parameter
    end
end
