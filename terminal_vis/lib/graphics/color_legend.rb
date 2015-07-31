# @Author: Benjamin Held
# @Date:   2015-05-30 13:34:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-31 09:18:46

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
    def print_color_for_data(value)
        create_output_string_for(value)
    end

    # prints color legend with given colors
    def print_color_legend
        puts "Legend: %.3f; %.3f; delta = %.3f" % [min_value, max_value, delta]
        @value_legend.each_pair { |key, value|
            2.times {print "#{value}" }
            # print " <= #{key}; "# todo: extended legend output
        }
        puts ""
    end

    private

    # creates color legend
    # @min_value + i * delta => key value at index i
    def create_color_legend
        length = 12
        @delta = (@max_value.to_f - @min_value.to_f).abs / length

        @value_legend = {
            (@min_value +  1 * @delta).round(3) => 'oo'.blue_bg.hide,
            (@min_value +  2 * @delta).round(3) => 'oo'.cyan_bg.hide,
            (@min_value +  3 * @delta).round(3) => 'oo'.light_blue_bg.hide,
            (@min_value +  4 * @delta).round(3) => 'oo'.light_cyan_bg.hide,
            (@min_value +  5 * @delta).round(3) => 'oo'.green_bg.hide,
            (@min_value +  6 * @delta).round(3) => 'oo'.light_green_bg.hide,
            (@min_value +  7 * @delta).round(3) => 'oo'.light_yellow_bg.hide,
            (@min_value +  8 * @delta).round(3) => 'oo'.yellow_bg.hide,
            (@min_value +  9 * @delta).round(3) => 'oo'.light_red_bg.hide,
            (@min_value + 10 * @delta).round(3) => 'oo'.red_bg.hide,
            (@min_value + 11 * @delta).round(3) => 'oo'.light_magenta_bg.hide,
            (@min_value + 12 * @delta).round(3) => 'oo'.magenta_bg.hide
        }
    end

    # creates output string for a given value
    # data_value => data from the dataset
    def create_output_string_for(data_value)
        @value_legend.values.each_index { |index|
            if (data_value <= @value_legend.keys[index])
                return @value_legend.values[index]
            end
        }
        return @value_legend.values.last
    end

end
