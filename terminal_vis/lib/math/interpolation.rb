# @Author: Benjamin Held
# @Date:   2015-08-04 11:44:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-29 08:56:48

module TerminalVis

  # This module holds methods and classes to interpolate data values with
  # different methods. The following interpolation methods are implemented:
  #   * Linear interpolation
  #   * Bilinear interpolation
  module Interpolation

    require_relative '../data/meta_data'
    require 'matrix'

    # interpolates the data for the provided coordinate and prints the result
    # param [MetaData] meta_data the meta data for the data series where the
    #  interpolation should be done
    def self.interpolate_for_coordinate(meta_data)
      index = TerminalVis.get_and_check_index(meta_data)

      x_coordinate = Float(TerminalVis.parameter_handler.
                                       repository.parameters[:coord][0])
      y_coordinate = Float(TerminalVis.parameter_handler.
                                       repository.parameters[:coord][1])

      value = BilinearInterpolation.bilinear_interpolation(meta_data,
                TerminalVis.data_repo.repository[meta_data].series[index],
                x_coordinate, y_coordinate)

      puts "Interpolated value for coordinate (#{x_coordinate}, " \
           "#{y_coordinate}) of dataset #{index} with result: " \
           "#{value.round(3)}."
    end

    # singleton method for linar interpolation between two points
    # @param [DataPoint] data_point0 first datapoint
    # @param [DataPoint] data_point1 second datapoint
    # @param [Float] x x-coordinate of the interpolation point
    # @param [Float] y y-coordinate of the interpolation point
    def self.linear_interpolation(data_point0, data_point1, x, y)
      coordinate = DataPoint.new(x, y)

      r = calculate_interpolation_factor(data_point0, data_point1, coordinate)
      ((1-r)* data_point0.value + r* data_point1.value).round(3)
    end

    # This class represents of a two dimensional point with a numeric value
    class DataPoint
      # @return [Vector] 2 dimensional coordinates of the data point
      attr_reader :coordinate
      # @return [Float] data value at point(x,y)
      attr_accessor :value

      # initialization
      # @param [Float] x coordinate in first dimension
      # @param [Float] y coordinate in second dimension
      # @param [Float] value data value at coordinate (x,y)
      def initialize(x=0.0, y=0.0, value=0.0)
        @coordinate = Vector[x,y]
        @value = value
      end

      # helper method to return the x coordinate
      # @return [Float] the x coordinate of the {DataPoint}
      def x
        @coordinate[0]
      end

      # helper method to return the y coordinate
      # @return [Float] the y coordinate of the {DataPoint}
      def y
        @coordinate[1]
      end

    end

  end

end

require_relative 'bilinear_interpolation'
