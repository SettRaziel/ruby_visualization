# @Author: Benjamin Held
# @Date:   2015-08-19 09:09:20
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-13 12:20:29

module ColorLegend

  # Class to color the output field according to color in {#value_legend}
  # attributes (see {ColorLegend::Base}). This class should be used when
  # visualizing the difference between two datasets.
  class ColorDelta < Base

    # initialization with constraint: max_value > min_value
    # @param [Float] min_value the minimum value
    # @param [Float] max_value the maximum value
    def initialize(min_value, max_value)
      if (max_value <= min_value)
        raise ArgumentError,
            " Error in ColorLegend: max_value <= min_value\n".red
      end

      super
      create_color_legend(7)
    end

    # creates an output string for given value
    # @param [Float] value the data value
    # @param [String] out_str form of the output string
    # @return [String] colored string for the given value
    def create_output_string_for(value, out_str)
      return out_str.blue_bg if (value <= @value_legend[0])
      return out_str.cyan_bg if (value <= @value_legend[1])
      return out_str.light_cyan_bg if (value <= @value_legend[2])
      return out_str.light_green_bg if (value <= @value_legend[3])
      return out_str.yellow_bg if (value <= @value_legend[4])
      return out_str.light_red_bg if (value <= @value_legend[5])
      out_str.red_bg
    end

  end

end
