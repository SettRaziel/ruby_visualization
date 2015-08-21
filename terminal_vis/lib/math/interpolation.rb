# @Author: Benjamin Held
# @Date:   2015-08-04 11:44:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-21 11:09:11

require_relative '../data/meta_data'
require 'matrix'

module TerminalVis

  module Interpolation

    # interpolates the data for the provided coordinate and prints the result
    def self.interpolate_for_coordinate(meta_data)
      index = TerminalVis.get_and_check_index(meta_data)

      x_coordinate = Float(TerminalVis.parameter_handler.
                                       repository.parameters[:coord][0])
      y_coordinate = Float(TerminalVis.parameter_handler.
                                       repository.parameters[:coord][1])

      value = Interpolation.bilinear_interpolation(meta_data,
                TerminalVis.data_repo.repository[meta_data].series[index],
                x_coordinate, y_coordinate)

      puts "Interpolated value for coordinate (#{x_coordinate}, " \
           "#{y_coordinate}) of dataset #{index} with result: " \
           "#{value.round(3)}."
    end

    # math class to interpolate data between a set of points. Raises
    # {RangeError} when the provided coordinates do not lie within the data
    # area of the meta data
    class Interpolation

      # method for bilinear interpolation
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @raise [RangeError] if coordinates are out of bounds
      # @return [Float] the interpolated data value for (x,y)
      def self.bilinear_interpolation(meta_data, data_set, x, y)
        check_data_range(meta_data, x, y)

        x_index = get_index_to_next_lower_datapoint(meta_data.domain_x, x)
        y_index = get_index_to_next_lower_datapoint(meta_data.domain_y, y)

        if ( coordinate_on_datapoint(meta_data.domain_x, x) &&
           coordinate_on_datapoint(meta_data.domain_y, y))
          # return value of datapoint
          return data_set.data[y_index][x_index]
        end

        if (coordinate_on_datapoint(meta_data.domain_x, x))
          # find the two datapoints with same x and call linear interpolation
          y_coordinate = get_coordinate_to_index(meta_data.domain_y, y_index)
          return linear_interpolation(
            DataPoint.new(x, y_coordinate, data_set.data[y_index][x_index]),
            DataPoint.new(x, y_coordinate + meta_data.domain_y.step,
              data_set.data[y_index + 1][x_index]), x, y)
        end

        if (coordinate_on_datapoint(meta_data.domain_y, y))
          # find the two datapoints with same y and call linear interpolation
          x_coordinate = get_coordinate_to_index(meta_data.domain_x, x_index)
          return linear_interpolation(
            DataPoint.new(x_coordinate, y, data_set.data[y_index][x_index]),
            DataPoint.new(x_coordinate + meta_data.domain_x.step, y,
              data_set.data[y_index][x_index + 1]), x, y)
        end

        return apply_bilinear_interpolation(meta_data, data_set, x, y)

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

      private

      # singleton method to check if the provided coordinates (x,y) lie within
      # the data area specified by the meta information
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [Float] x x-coordinate of the provided point
      # @param [Float] y y-coordinate of the provided point
      def self.check_data_range(meta_data, x, y)
        if ( !coordinate_in_dataset(meta_data.domain_x, x) ||
           !coordinate_in_dataset(meta_data.domain_y, y))
          raise RangeError, " Error: coordinate (#{x}, #{y}) does not lie" \
                     " in the data domain provided by meta_data."
        end
      end

      # singleton method to calculate the bilinear interpolation
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the interpolated data value for (x,y)
      def self.apply_bilinear_interpolation(meta_data, data_set, x, y)
        x_index = get_index_to_next_lower_datapoint(meta_data.domain_x, x)
        y_index = get_index_to_next_lower_datapoint(meta_data.domain_y, y)

        y_coordinate = get_coordinate_to_index(meta_data.domain_y, y_index)
        x_coordinate = get_coordinate_to_index(meta_data.domain_x, x_index)
        #getting boundary data points
        d_xy = DataPoint.new(x_coordinate,y_coordinate,
                   data_set.data[y_index][x_index])
        d_x1y = DataPoint.new(x_coordinate + meta_data.domain_x.step,
                    y_coordinate, data_set.data[y_index][x_index + 1])
        d_xy1 = DataPoint.new(x_coordinate,
                    y_coordinate + meta_data.domain_y.step,
                    data_set.data[y_index + 1][x_index])
        d_x1y1 = DataPoint.new(x_coordinate + meta_data.domain_x.step ,
                     y_coordinate + meta_data.domain_y.step,
                     data_set.data[y_index + 1][x_index + 1])
        coordinate = DataPoint.new(x, y)

        # interpolate
        r = calculate_interpolation_factor(d_xy, d_x1y, coordinate)
        s = calculate_interpolation_factor(d_xy, d_xy1, coordinate)
        (1-r) * (1-s) * d_xy.value + r * (1-s) * d_x1y.value +
        r * s * d_x1y1.value + (1-r) * s * d_xy1.value
      end

      # singleton method to check if the provided coordinate lies within
      # the given domain of the dataset
      # @param [DataDomain] data_domain domain of the meta_data
      #   corresponding to the coordinate
      # @param [DataPoint] coordinate component of the coordinate to check
      # @return [Boolean] true, if in dataset, false: if not
      def self.coordinate_in_dataset(data_domain, coordinate)
        (coordinate <= data_domain.upper && coordinate >= data_domain.lower)
      end

      # singleton method to check if a provided coordinate lies on a data point
      # of the dataset
      # @param [DataDomain] data_domain domain of the meta_data corresponding
      #   to the coordinate
      # @param [DataPoint] coordinate component of the coordinate to check
      # @return [Numeric] the modulus of the coordinate and {DataDomain.step}
      def self.coordinate_on_datapoint(data_domain, coordinate)
        (coordinate % data_domain.step == 0)
      end

      # singleton method to get the index to the next down rounded datapoint
      # @param [DataDomain] data_domain domain of the meta_data corresponding
      #   to the coordinate
      # @param [DataPoint] coordinate component of the coordinate to check
      # @return [Numeric] the index of the next coordinate value (rounded down)
      def self.get_index_to_next_lower_datapoint(data_domain, coordinate)
        ((coordinate - data_domain.lower) / data_domain.step).floor
      end

      # singleton methode to calculate coordinate value to the corresponding
      # index
      # @param [DataDomain] data_domain domain of the meta_data which coordinate
      #   should be calculated
      # @param [Integer] index index of the data set to calculate the
      #   corresponding coordinate
      def self.get_coordinate_to_index(data_domain, index)
        data_domain.lower + index * data_domain.step
      end

      # singleton method to calculate interpolation coefficient with
      # accuracy to the fifth digit
      # @param [DataPoint] data_point0 DataPoint with coordinates and value
      #   needed for the interpolation
      # @param [DataPoint] data_point1 DataPoint with coordinates and value
      #   needed for the interpolation
      # @param [DataPoint] coordinate DataPoint with coordinate where the data
      #   should be interpolated
      def self.calculate_interpolation_factor(data_point0, data_point1,
                                      coordinate)
        ( (coordinate.coordinate - data_point0.coordinate).
          dot(data_point1.coordinate - data_point0.coordinate) /
          (data_point1.coordinate - data_point0.coordinate).magnitude**2).
        round(5)
      end

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

    end

  end

end
