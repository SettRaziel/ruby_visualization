# @Author: Benjamin Held
# @Date:   2015-08-23 10:07:26
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-06 12:56:27

module TerminalVis

  module Interpolation

    # math class to interpolate data between a set of points. Raises
    # {RangeError} when the provided coordinates do not lie within the data
    # area of the meta data
    class BilinearInterpolation

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

        indices = get_data_indices(meta_data, x, y) # with [x_index, y_index]

        if ( coordinate_on_datapoint(meta_data.domain_x, x) &&
             coordinate_on_datapoint(meta_data.domain_y, y))
          # return value of datapoint
          return data_set.data[indices[1]][indices[0]]
        end

        if (coordinate_on_datapoint(meta_data.domain_x, x))
          # point lies between two data point with same x value
          return handle_coordinate_on_x(meta_data, data_set, indices, x, y)
        end

        if (coordinate_on_datapoint(meta_data.domain_y, y))
          # point lies between two data point with same x value
          return handle_coordinate_on_y(meta_data, data_set, indices, x, y)
        end

        return apply_bilinear_interpolation(meta_data, data_set, x, y)

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

      # calculates the two nearest, lower indices for the given coordinates
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      def self.get_data_indices(meta_data, x, y)
        x_index = get_index_to_next_lower_datapoint(meta_data.domain_x, x)
        y_index = get_index_to_next_lower_datapoint(meta_data.domain_y, y)

        [x_index, y_index]
      end

      # calculates the coordinates to the given indices
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [Array] indices the two indices [x, y] for the lowest data point
      #  of the interpolation
      # @return [Array] coordinates associated to the given indices
      def self.get_coordinates_to_indices(meta_data, indices)
        y_coordinate = get_coordinate_to_index(meta_data.domain_y, indices[1])
        x_coordinate = get_coordinate_to_index(meta_data.domain_x, indices[0])

        [x_coordinate, y_coordinate]
      end

      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Array] indices the two indices [x, y] for the lowest data point
      #  of the interpolation
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      def self.handle_coordinate_on_x(meta_data, data_set, indices, x, y)
        # find the two datapoints with same x and call linear interpolation
        y_coordinate = get_coordinate_to_index(meta_data.domain_y, indices[1])
        return linear_interpolation(
          DataPoint.new(x, y_coordinate, data_set.data[indices[1]][indices[0]]),
          DataPoint.new(x, y_coordinate + meta_data.domain_y.step,
                        data_set.data[indices[1] + 1][indices[0]]), x, y)
      end

      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Array] indices the two indices [x, y] for the lowest data point
      #  of the interpolation
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      def self.handle_coordinate_on_y(meta_data, data_set, indices, x, y)
        # find the two datapoints with same y and call linear interpolation
        x_coordinate = get_coordinate_to_index(meta_data.domain_x, indices[0])
        return linear_interpolation(
          DataPoint.new(x_coordinate, y, data_set.data[indices[1]][indices[0]]),
          DataPoint.new(x_coordinate + meta_data.domain_x.step, y,
                        data_set.data[indices[1]][indices[0] + 1]), x, y)
      end

      # singleton method to calculate the bilinear interpolation
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the interpolated data value for (x,y)
      def self.apply_bilinear_interpolation(meta_data, data_set, x, y)
        #getting boundary data points
        d_xy = create_data_point(0, 0, meta_data, data_set, x, y)
        d_x1y = create_data_point(1, 0, meta_data, data_set, x, y)
        d_xy1 = create_data_point(0, 1, meta_data, data_set, x, y)
        d_x1y1 = create_data_point(1, 1, meta_data, data_set, x, y)
        coordinate = DataPoint.new(x, y)

        # interpolate
        r = calculate_interpolation_factor(d_xy, d_x1y, coordinate)
        s = calculate_interpolation_factor(d_xy, d_xy1, coordinate)
        (1-r) * (1-s) * d_xy.value + r * (1-s) * d_x1y.value +
        r * s * d_x1y1.value + (1-r) * s * d_xy1.value
      end

      # creation of the boundary data points for the bilinear interpolation
      # @param [Integer] delta_x delta value in x for the grid with values
      #  0 or 1
      # @param [Integer] delta_y delta value in y for the grid with values
      #  0 or 1
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [DataPoint] corresponding data point
      def self.create_data_point(delta_x, delta_y, meta_data, data_set, x, y)
        indices = get_data_indices(meta_data, x, y) # with [x_index, y_index]

        y_coordinate = get_coordinate_to_index(meta_data.domain_y, indices[1])
        x_coordinate = get_coordinate_to_index(meta_data.domain_x, indices[0])

        DataPoint.new(x_coordinate + delta_x * meta_data.domain_x.step,
                      y_coordinate + delta_y * meta_data.domain_y.step,
                      data_set.data[indices[1] + delta_y][indices[0] + delta_x])
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
      #  of the dataset
      # @param [DataDomain] data_domain domain of the meta_data corresponding
      #  to the coordinate
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

  end

end
