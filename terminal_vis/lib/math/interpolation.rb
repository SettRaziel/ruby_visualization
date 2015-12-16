# @Author: Benjamin Held
# @Date:   2015-08-04 11:44:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-16 11:54:39

module TerminalVis

  # This module holds methods and classes to interpolate data values with
  # different methods. The following interpolation methods are implemented:
  #   * Linear interpolation
  #   * Bilinear interpolation
  module Interpolation

    require_relative '../data/meta_data'
    require_relative '../data/data_set'
    require 'matrix'

    # interpolates the data for the provided coordinate and prints the result
    # @param [MetaData] meta_data the meta data for the data series where the
    #  interpolation should be done
    # @param [Hash] coordinates the coordinates for the interpolation
    # @param [DataSet] data_set the dataset where the interpolation shall be
    #  applied on
    # @return [Float] the interpolated value for the given input
    def self.interpolate_for_coordinate(meta_data, coordinates, data_set)

      x_coordinate = coordinates[:x]
      y_coordinate = coordinates[:y]

      BilinearInterpolation.bilinear_interpolation(meta_data, data_set,
                                                   x_coordinate, y_coordinate)
    end

    # singleton method for linear interpolation between two points
    # @param [DataPoint] data_point0 first datapoint
    # @param [DataPoint] data_point1 second datapoint
    # @param [Float] x x-coordinate of the interpolation point
    # @param [Float] y y-coordinate of the interpolation point
    # @return [Float] the interpolated value for the given input
    def self.linear_interpolation_for_coordinate(data_point0, data_point1, x, y)
      LinearInterpolation.linear_interpolation(data_point0, data_point1, x, y)
    end

    # singleton method to interpolate the data values specified for the region
    # defined by the coordinates and the interval and delta values
    # @param [MetaData] meta_data the meta data of the considered data set
    # @param [DataSet] data_set the data_set which values are taken to
    #   interpolate the region
    # @param [Hash] coordinates a hash containing the x- and y-coordinate
    # @param [Hash] values a hash containing all relevant values for the
    #   region interpolation
    def self.region_interpolation(meta_data, data_set, coordinates, values)
      ri = RegionInterpolation.new(values[:inter], values[:delta],
                                   values[:inter], values[:delta])
      ri.interpolate_region(coordinates[:x], coordinates[:y],
                                     meta_data, data_set)
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
    #   fifth digit
    def self.calculate_interpolation_factor(data_point0, data_point1, x, y)
      coordinate = DataPoint.new(x, y)
      ( (coordinate.coordinate - data_point0.coordinate).
        dot(data_point1.coordinate - data_point0.coordinate) /
        (data_point1.coordinate - data_point0.coordinate).magnitude**2).
      round(5)
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
require_relative 'linear_interpolation'
require_relative 'region_interpolation'
