# @Author: Benjamin Held
# @Date:   2015-05-30 13:34:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-05-31 13:32:06

class ColorLegend
    attr_reader :value_legend, :min_value, :max_value, :delta

    def initialize(min_value, max_value)
        @min_value = min_value
        @max_value = max_value
        create_color_legend()
    end

    def print_color_for_data(value)
        create_output_string_for(value)
    end

    def print_interval_borders
        @value_legend.each_index {
            |i| puts "value at #{i}: #{@value_legend[i]}"
        }
    end

    def print_color_legend
        puts "Legend: #{min_value}; #{max_value}"
        @value_legend.each { |value| print create_output_string_for(value) }
        puts create_output_string_for(max_value)
    end

    private

    def create_color_legend
        length = 6
        @value_legend = Array.new(length+1)
        @delta = (@max_value.to_f - @min_value.to_f).abs / length
        @value_legend.each_index {
            |i| @value_legend[i] = @min_value + i*@delta
        }

    end

    def create_output_string_for(value)
        return 'oo'.blue_bg.hide if (value <= @value_legend[1])
        return 'oo'.cyan_bg.hide if (value <= @value_legend[2])
        return 'oo'.green_bg.hide if (value <= @value_legend[3])
        return 'oo'.yellow_bg.hide if (value <= @value_legend[4])
        return 'oo'.red_bg.hide if (value <= @value_legend[5])
        'oo'.magenta_bg.hide
    end

end