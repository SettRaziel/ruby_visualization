# @Author: Benjamin Held
# @Date:   2015-06-12 10:45:36
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-24 17:29:18

# Parameter repository storing the valid parameter of the script
# @parameter_regex => Hash of regular expressions of valid parameters
# @parameter_used => Hash of used parameters in script call
class ParameterRepository
    attr_reader :parameter_regex, :parameter_used

    def initialize
        @parameter_regex = Hash.new()
        @parameter_used = Hash.new()
        @parameter_regex["--help"] = /--help/   # help parameter
        # parameter for using file with meta data
        @parameter_regex["-m"] = /-m/
        # parameter for the index of the data set that should be shown
        @parameter_regex["-i"] = /-i/
    end
end
