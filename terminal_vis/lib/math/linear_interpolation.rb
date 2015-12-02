# @Author: Benjamin Held
# @Date:   2015-12-01 16:52:18
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-02 07:32:58

module TerminalVis

  module Interpolation

    # math class to apply linear interpolation between two points
    # @raise [RangeError] when the provided coordinates do not lie within
    #   the data area of the meta data
    class LinearInterpolation

      # singleton method for linear interpolation between two points
      # @param [DataPoint] data_point0 first datapoint
      # @param [DataPoint] data_point1 second datapoint
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      def self.linear_interpolation(data_point0, data_point1, x, y)
        r = Interpolation::calculate_interpolation_factor(data_point0,
                                                          data_point1, x, y)
        ((1-r) * data_point0.value + r * data_point1.value).round(3)
      end

    end

  end

end
