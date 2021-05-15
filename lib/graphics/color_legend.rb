# This module groups the different color legends that are used to visualize the
# output. The class {BaseLegend} provides the basic methods that are needed. Child
# classes only need to implement the method {BaseLegend#create_output_string_for}.
module ColorLegend

require 'ruby_utils/string'

require_relative 'base_legend'
require_relative 'color_data'
require_relative 'color_delta'

end
