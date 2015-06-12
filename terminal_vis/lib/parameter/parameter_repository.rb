# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-12 11:14:01

class ParameterRepository
    attr_reader :parameter_regex

    def initialize
        @parameter_regex = Hash.new()
        @parameter_regex["--help"] = /--help/
        @parameter_regex["-m"] = /-m/
    end
end
