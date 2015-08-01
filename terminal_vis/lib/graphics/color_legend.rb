# @Author: Benjamin Held
# @Date:   2015-05-30 13:34:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-01 11:21:49

require_relative '../graphics/string'

# Class to color output field according to color in @value_legend
# @value_legend => color map for value interval
# @min_value => left interval value
# @max_value => right interval value
# @delta => steps between two values
class ColorLegend
    attr_reader :value_legend, :min_value, :max_value, :delta

    # initialization
    # min_value => minimum value
    # max_value => maximum value-
    # constraint: max_value > min_value
    def initialize(min_value, max_value)
        if (max_value <= min_value)
            raise ArgumentError,
                  "Error in ColorLegend: max_value <= min_value\n"
        end
        @min_value = min_value
        @max_value = max_value
        create_color_legend()
    end

    # creates output string for given value
    # value => data value
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

    # prints color legend with given colors
    def print_color_legend
        puts "Legend: %.3f; %.3f; delta = %.3f" % [min_value, max_value, delta]
        @value_legend.each { |value|
            2.times {print create_output_string_for(value, '  ') }
            # print " <= #{value}; "# todo: extended legend output
        }
        puts ""
    end

    private

    # creates color legend
    # @min_value + i * delta => value at index i + 1
    def create_color_legend
        length = 12
        @delta = (@max_value.to_f - @min_value.to_f).abs / length

        @value_legend = Array.new(length)

        @value_legend.each_index { |index|
            @value_legend[index] = (@min_value +  (index + 1) * @delta).round(3)
        }
    end

end
