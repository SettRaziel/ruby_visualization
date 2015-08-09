# @Author: Benjamin Held
# @Date:   2015-08-04 11:44:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-09 13:12:58

require_relative '../data/meta_data'
require 'matrix'

# singleton math class to interpolate data between a set of points
# raises RangeError
class Interpolator

    # singleton method for bilinear interpolation
    # meta_data => meta_data of the used dataset
    # data_set => dataset where a coordinate should be interpolated
    # x => x-coordinate of the interpolation point
    # y => y-coordinate of the interpolation point
    # raises RangeError if coordinates are out of bounds
    def self.bilinear_interpolation(meta_data, data_set, x, y)
        if ( !coordinate_in_dataset(meta_data.domain_x, x) ||
             !coordinate_in_dataset(meta_data.domain_x, x))
            raise RangeError, " coordinate (#{x}, #{y}) do not lie with " \
                               "data domain."
        end

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
                    data_set.data[y_index + 1][x_index]),
                DataPoint.new(x,y))
        end


        if (coordinate_on_datapoint(meta_data.domain_y, y))
            # find the two datapoints with same y and call linear interpolation
            x_coordinate = get_coordinate_to_index(meta_data.domain_x, x_index)
            return linear_interpolation(
                DataPoint.new(x_coordinate, y, data_set.data[y_index][x_index]),
                DataPoint.new(x_coordinate + meta_data.domain_x.step, y,
                    data_set.data[y_index][x_index + 1]),
                DataPoint.new(x,y))
        end

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

    # singleton method for linar interpolation between two points
    # data_point0 => first datapoint
    # data_point1 => second datapoint
    # coordinate => datapoint of interpolation
    def self.linear_interpolation(data_point0, data_point1, coordinate)
        r = calculate_interpolation_factor(data_point0, data_point1, coordinate)
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

    # singleton method to get the index to the next down rounded datapoint
    # data_domain => domain of the meta_data corresponding to the coordinate
    # coordinate => component of the coordinate to check
    def self.get_index_to_next_lower_datapoint(data_domain, coordinate)
        ((coordinate - data_domain.lower) / data_domain.step).floor
    end

    # singleton methode to calculate coordinate value to the corresponding
    # index
    # data_domain => domain of the meta_data which coordinate should be
    # calculated
    # index => index of the data set to calculate the corresponding coordinate
    def self.get_coordinate_to_index(data_domain, index)
        data_domain.lower + index * data_domain.step
    end

    # singleton method to calculate interpolation coefficient with
    # accuracy to the fifth digit
    # data_point0 => DataPoint with coordinates and value needed for the
    # interpolation
    # data_point1 => DataPoint with coordinates and value needed for the
    # interpolation
    # coordinate => DataPoint with coordinate where the data should be
    # interpolated
    def self.calculate_interpolation_factor(data_point0, data_point1,
                                                                  coordinate)
        ( (coordinate.coordinate - data_point0.coordinate).
          dot(data_point1.coordinate - data_point0.coordinate) /
          (data_point1.coordinate - data_point0.coordinate).magnitude**2).
        round(5)
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
