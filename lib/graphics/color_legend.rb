# @Author: Benjamin Held
# @Date:   2015-05-30 13:34:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2018-02-02 15:39:46

# This module groups the different color legends that are used to visualize the
# output. The class {BaseLegend} provides the basic methods that are needed. Child
# classes only need to implement the method {BaseLegend#create_output_string_for}.
module ColorLegend

require_relative '../string/string'

require_relative 'base_legend'
require_relative 'color_data'
require_relative 'color_delta'

end
