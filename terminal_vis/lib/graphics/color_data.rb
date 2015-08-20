# @Author: Benjamin Held
# @Date:   2015-08-19 08:56:50
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-20 10:42:46

module ColorLegend

  # Class to color output field according to color in {value_legend}
  # attributes ( see {ColorLegend::Base}). This class should be used when
  # visualizing a dataset.
  class ColorData < Base

    # initialization with constraint: max_value > min_value
    # @param [Float] min_value minimum value
    # @param [Float] max_value maximum value
    def initialize(min_value, max_value)
      if (max_value <= min_value)
        raise ArgumentError,
            "Error in ColorLegend: max_value <= min_value\n"
      end

      super
      create_color_legend(12)
    end

    # creates output string for given value
    # @param [Float] value the data value
    # @param [String] out_str form of the output string
    # @return [String] colored string for given {value}
    def create_output_string_for(value, out_str)
      return out_str.blue_bg if (value <= @value_legend[0])
      return out_str.cyan_bg if (value <= @value_legend[1])
      return out_str.light_blue_bg if (value <= @value_legend[2])
      return out_str.light_cyan_bg if (value <= @value_legend[3])
      return out_str.green_bg if (value <= @value_legend[4])
      return out_str.light_green_bg if (value <= @value_legend[5])
      return out_str.light_yellow_bg if (value <= @value_legend[6])
      return out_str.yellow_bg if (value <= @value_legend[7])
      return out_str.light_red_bg if (value <= @value_legend[8])
      return out_str.red_bg if (value <= @value_legend[9])
      return out_str.light_magenta_bg if (value <= @value_legend[10])
      out_str.magenta_bg
    end

  end

end
