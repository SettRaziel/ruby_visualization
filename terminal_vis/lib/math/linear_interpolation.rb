# @Author: Benjamin Held
# @Date:   2015-12-01 16:52:18
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-01 17:03:14

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
        r = calculate_interpolation_factor(data_point0, data_point1, x, y)
        ((1-r)* data_point0.value + r* data_point1.value).round(3)
      end

      # singleton method to calculate interpolation coefficient with
      # accuracy to the fifth digit
      # @param [DataPoint] data_point0 DataPoint with coordinates and value
      #   needed for the interpolation
      # @param [DataPoint] data_point1 DataPoint with coordinates and value
      #   needed for the interpolation
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the calculated interpolation factor rounded to the
      #  fifth digit
      def self.calculate_interpolation_factor(data_point0, data_point1, x, y)
        coordinate = DataPoint.new(x, y)
        ( (coordinate.coordinate - data_point0.coordinate).
          dot(data_point1.coordinate - data_point0.coordinate) /
          (data_point1.coordinate - data_point0.coordinate).magnitude**2).
        round(5)
      end

    end

  end

end
