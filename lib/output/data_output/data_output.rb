# @Author: Benjamin Held
# @Date:   2015-05-31 15:08:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2018-02-01 13:22:45

require_relative '../../data/data_input'
require_relative '../../data/meta_data'
require_relative '../../graphics/color_legend'
require_relative '../../graphics/string'
require_relative '../../scaling/terminal_size'
require_relative '../../scaling/dataset_scaling'
require_relative '../data_axis'

# This module groups the different output formats that are used to visualize the
# output. The class {BaseOutput} provides the basic methods that are needed.
module DataOutput

  require_relative 'base_output'
  require_relative 'dataset_output'
  require_relative 'delta_output'
  require_relative 'region_output'
  require_relative 'single_output'
  require_relative 'scaled_output'
  require_relative 'scaled_dataset_output'
  require_relative 'scaled_delta_output'

end
