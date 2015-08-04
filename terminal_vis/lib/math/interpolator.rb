# @Author: Benjamin Held
# @Date:   2015-08-04 11:44:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-04 13:14:42

require_relative '../data/meta_data'
require 'matrix'

# singleton math class to interpolate data between a set of points
class Interpolator

    # singleton method for bilinear interpolation
    # meta_data => meta_data of the used dataset
    # data_set => dataset where a coordinate should be interpolated
    # x => x-coordinate of the interpolation point
    # y => y-coordinate of the interpolation point
    def self.bilinear_interpolation(meta_data, data_set, x, y)
        if ( !coordinate_in_dataset(meta_data.domain_x, x) ||
             !coordinate_in_dataset(meta_data.domain_x, x))
            raise RangeError, " coordinate (#{x}, #{y}) do not lie with " \
                               "data domain."
        end

        if ( coordinate_on_datapoint(meta_data.domain_x, x) &&
             coordinate_on_datapoint(meta_data.domain_y, y))
            # return value at datapoint
        end

        if ( coordinate_on_datapoint(meta_data.domain_x, x) ||
             coordinate_on_datapoint(meta_data.domain_y, y))
            # find the two datapoints and call linear interpolation
        end

        #do bilinear interpolation
    end

    # singleton method for linar interpolation between two points
    # data_point0 => first datapoint
    # data_point1 => second datapoint
    # coordinate => datapoint of interpolation
    def self.linear_interpolation(data_point0, data_point1, coordinate)
        r = (coordinate.coordinate - data_point0.coordinate).
        dot(data_point1.coordinate - data_point0.coordinate) /
        (data_point1.coordinate.magnitude**2 -
         data_point0.coordinate.magnitude**2).abs
        ((1-r)* data_point0.value + r* data_point1.value).round(3)
    end

    private

    # singleton method to check if the provided coordinate lies within
    # the given domain of the dataset
    # data_domain => domain of the meta_data corresponding to the coordinate
    # coordinate => component of the coordinate to check
    def self.coordinate_in_dataset(data_domain, coordinate)
        (coordinate <= data_domain.upper && coordinate >= data_domain.lower)
    end

    # singleton method to check if a provided coordinate lies on a data point
    # of the dataset
    # data_domain => domain of the meta_data corresponding to the coordinate
    # coordinate => component of the coordinate to check
    def self.coordinate_on_datapoint(data_domain, coordinate)
        (coordinate % data_domain.step == 0)
    end

end

# representation of a two dimensional point with a numeric value
# @coordinate => 2 dimensional coordinates of the data point
# @value => data value at point(x,y)
class DataPoint
    attr_reader :coordinate
    attr_accessor :value

    def initialize(x=0.0, y=0.0, value=0.0)
        @coordinate = Vector[x,y]
        @value = value
    end

end
