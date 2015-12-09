# @Author: Benjamin Held
# @Date:   2015-12-07 17:22:54
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-09 19:42:11

module TerminalVis

  module Interpolation

    class RegionInterpolation
      attr_reader :data

      def initialize(interval_x, delta_x, interval_y, delta_y)
        @interval_x = interval_x
        @delta_x = delta_x
        @interval_y = interval_y
        @delta_y = delta_y
        @data = Hash.new()

        check_value(@interval_x)
        check_value(@interval_y)
        check_value(@delta_x)
        check_value(@delta_y)
      end

      def interpolate_region(x, y, meta_data, data_set)
      y_run = y - @interval_y
      index = 2 * @interval_y / @delta_y

        while (y_run <= (y + @interval_y).round(3))
          @data[index] = create_values_for_line(x, y_run, meta_data, data_set)
          index -= 1
          y_run = (y_run + @delta_y).round(3)
        end

      return @data
      end

      private
      attr :interval_x
      attr :delta_x
      attr :interval_y
      attr :delta_y

      def create_values_for_line(x, y_run, meta_data, data_set)
          row = Array.new()
          x_run = x - @interval_x
          while (x_run <= (x + @interval_x).round(3))
            row << BilinearInterpolation.bilinear_interpolation(meta_data,
                                         data_set, x_run, y_run).round(5)
            x_run = (x_run + @delta_x).round(3)
          end
          return row
      end

      def check_value(value)
        if (value <= 0)
          raise ArgumentError, " Error in RegionInterpolation: #{value} <= 0."
        end
      end

    end

  end

end
