# @Author: Benjamin Held
# @Date:   2015-12-07 17:22:54
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-12 18:02:56

module TerminalVis

  module Interpolation

    # class to interpolate a given section of the possible data space
    # @raise [ArgumentError] if one of the required parameter is <= 0
    class RegionInterpolation
      # @return [Hash] a hash with the values of the interpolated section
      attr_reader :data

      # initialization
      # @param [Float] interval_x the half portion of the x-dimension that
      #   should be interpolated
      # @param [Float] delta_x the step size in x between to interpolation
      #   points
      # @param [Float] interval_y the half portion of the y-dimension that
      #   should be interpolated
      # @param [Float] delta_y the step size in y between to interpolation
      #   points
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

      # method to start the interpolation for the given centroid (x,y)
      # @param [Float] x the x-coordinate of the centroid
      # @param [Float] y the y-coordinate of the centroid
      # @param [MetaData] meta_data the required meta data
      # @param [DataSet] data_set the dataset which values are used for the
      #   interpolation
      # @return [Hash] the interpolated data
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
      # @return [Float] the half portion of the x-dimension that should be
      #   interpolated
      attr :interval_x
      # @param [Float] the step size in x between to interpolation points
      attr :delta_x
      # @return [Float] the half portion of the y-dimension that should be
      #   interpolated
      attr :interval_y
      # @param [Float] the step size in y between to interpolation points
      attr :delta_y

      # method to create the interpolated values for a given y value
      # @param [Float] x the x-coordinate of the starting point
      # @param [Float] y_run the y-coordinate of the actual row
      # @param [MetaData] meta_data the required meta data
      # @param [DataSet] data_set the dataset which values are used for the
      #   interpolation
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

      # method to check for positive values
      # @param [Float] value the given value
      # @raise [ArgumentError] if one of the required parameter is <= 0
      def check_value(value)
        if (value <= 0)
          raise ArgumentError, " Error in RegionInterpolation: #{value} <= 0."
        end
      end

    end

  end

end
