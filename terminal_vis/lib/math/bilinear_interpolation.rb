# @Author: Benjamin Held
# @Date:   2015-08-23 10:07:26
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-14 17:41:25

module TerminalVis

  module Interpolation

    # math class to interpolate data between a set of points
    # @raise [RangeError] when the provided coordinates do not lie within
    #   the data area of the meta data
    class BilinearInterpolation

      # method for bilinear interpolation
      # @param [MetaData] meta_data meta_data of the used dataset
      # @param [DataSet] data_set dataset where a
      #   coordinate should be interpolated
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the interpolated data value for (x,y)
      def self.bilinear_interpolation(meta_data, data_set, x, y)
        set_attributes(meta_data, data_set)
        check_data_range(x, y)

        apply_bilinear_interpolation(x, y)
      end

      private
      # @return [DataSet] the used data set
      attr :data_set
      # @return [MetaData] the used meta data
      attr :meta_data

      # singleton method to set the attributes at the beginning of an
      # interpolation
      # @param [MetaData] meta_data the meta data required for the
      #  bilinear interpolation
      # @param [DataSet] data_set the dataset required for the bilinear
      #  interpolation
      def self.set_attributes(meta_data, data_set)
        @data_set = data_set
        @meta_data = meta_data
      end

      # singleton method to check if the provided coordinates (x,y) lie within
      # the data area specified by the meta information
      # @param [Float] x x-coordinate of the provided point
      # @param [Float] y y-coordinate of the provided point
      # @raise [RangeError] if the data lies outside the meta data boundaries
      def self.check_data_range(x, y)
        if ( !coordinate_in_dataset(@meta_data.domain_x, x) ||
             !coordinate_in_dataset(@meta_data.domain_y, y))
          raise RangeError, " Error: coordinate (#{x}, #{y}) does not lie" \
                     " in the data domain provided by meta_data."
        end
      end

      # calculates the two nearest, lower indices for the given coordinates
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Hash] Hash with the two indices
      def self.get_data_indices(x, y)
        x_index = get_index_to_next_lower_datapoint(@meta_data.domain_x, x)
        y_index = get_index_to_next_lower_datapoint(@meta_data.domain_y, y)

        { :x => x_index, :y => y_index }
      end

      # singleton method to calculate the bilinear interpolation
      # applies the formula:
      #     (1-r)*(1-s)*d(x,y) + r*(1-s)*d(x+1,y) +
      #     r*s*d(x+1,y+1) + (1-r)*s*d(x,y+1)
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the interpolated data value for (x,y)
      def self.apply_bilinear_interpolation(x, y)
        boundary = calculate_boundary_datapoints(x, y)

        # interpolate
        r = calculate_interpolation_factor(boundary[:d_xy],
                                           boundary[:d_x1y], x, y)
        s = calculate_interpolation_factor(boundary[:d_xy],
                                           boundary[:d_xy1], x, y)

        calculate_interpolation_result(1-r, 1-s, boundary[:d_xy].value) +
        calculate_interpolation_result(r, 1-s, boundary[:d_x1y].value) +
        calculate_interpolation_result(r, s, boundary[:d_x1y1].value) +
        calculate_interpolation_result(1-r, s, boundary[:d_xy1].value)
      end

      # creation of the boundary data points for the bilinear interpolation
      # @param [Integer] delta_x delta value in x for the grid with values
      #  in the interval of 0 to 1
      # @param [Integer] delta_y delta value in y for the grid with values
      #  in the interval of 0 to 1
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [DataPoint] corresponding data point
      def self.create_data_point(delta_x, delta_y, x, y)
        indices = get_data_indices(x, y) # with [x_index, y_index]
        x_coordinate = @meta_data.domain_x.get_coordinate_to_index(indices[:x])+
                       delta_x * @meta_data.domain_x.step
        y_coordinate = @meta_data.domain_y.get_coordinate_to_index(indices[:y])+
                       delta_y * @meta_data.domain_y.step
        data = @data_set.data[indices[:y] + delta_y][indices[:x] + delta_x]

        DataPoint.new(x_coordinate, y_coordinate, data)
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

      # singleton method to get the index to the next down rounded datapoint
      # @param [DataDomain] data_domain domain of the meta_data corresponding
      #   to the coordinate
      # @param [DataPoint] coordinate component of the coordinate to check
      # @return [Numeric] the index of the next coordinate value (rounded down)
      def self.get_index_to_next_lower_datapoint(data_domain, coordinate)
        ((coordinate - data_domain.lower) / data_domain.step).floor
      end

      # singleton method to calculate the necessary boundary points
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Hash] Hash with the four boundary points of (x,y)
      def self.calculate_boundary_datapoints(x, y)
        boundary = Hash.new()

        #getting boundary data points
        boundary[:d_xy] = create_data_point(  0, 0, x, y)
        boundary[:d_x1y] = create_data_point( 1, 0, x, y)
        boundary[:d_xy1] = create_data_point( 0, 1, x, y)
        boundary[:d_x1y1] = create_data_point(1, 1, x, y)

        return boundary
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

      # singleton method to calculate the result of the bilinear interpolation
      # @param [Float] r the interpolation factor in x
      # @param [Float] s the interpolation factor in y
      # @param [Float] value the data value for this factors
      # @return [Float] the result of the product of the variables
      def self.calculate_interpolation_result(r, s, value)
        r * s * value
      end

    end

  end

end
