# This module holds the main singleton methods that are called from the script.
# It also stores the data ans parameter repository so it can be called from
# the other classes and modules if they need data oder parameter informations.
module TerminalVis

  module Interpolation

    # math class to interpolate data between a set of points
    # @raise [RangeError] when the provided coordinates do not lie within
    #   the data area of the {MetaData::VisMetaData}
    class BilinearInterpolation

      # method for bilinear interpolation
      # @param [VisMetaData] meta_data meta data of the used dataset
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

      # method to return the boundary point for a calculated interpolation
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Hash] the hash containing the boundary points for the given
      #   interpolation, if at least one interpolation has been run
      def self.get_boundary_points(x, y)
        check_data_range(x, y)
        calculate_boundary_datapoints(x, y)
      end

      private
      # @return [DataSet] the used data set
      attr :data_set
      # @return [VisMetaData] the used meta data
      attr :meta_data

      # singleton method to set the attributes at the beginning of an
      # interpolation
      # @param [VisMetaData] meta_data the meta data required for the
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
                     " in the data domain provided by meta_data.".red
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
        return boundary_case(x,y) if check_for_upper_boundary(x, y)
        boundary = calculate_boundary_datapoints(x, y)

        # interpolate
        r = Interpolation::calculate_interpolation_factor(boundary[:d_xy],
                                                          boundary[:d_x1y],
                                                          x, y)
        s = Interpolation::calculate_interpolation_factor(boundary[:d_xy],
                                                          boundary[:d_xy1],
                                                          x, y)

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
        coordinates = determine_coordinates(indices, delta_x, delta_y)
        begin
          data = @data_set.data[indices[:y] + delta_y][indices[:x] + delta_x]
          DataPoint.new(coordinates[:x], coordinates[:y], data)
        rescue StandardError
          DataPoint.new(coordinates[:x], coordinates[:y], nil)
        end
      end

      # singleton method to calculate the required coordinates for the
      # requested data
      # @param [Hash] indices the indices corresponding to the coordinates
      # @param [Integer] delta_x delta value in x for the grid with values
      #  in the interval of 0 to 1
      # @param [Integer] delta_y delta value in y for the grid with values
      #  in the interval of 0 to 1
      def self.determine_coordinates(indices, delta_x, delta_y)
        coordinates = Hash.new()
        coordinates[:x] = (@meta_data.domain_x.
                          get_coordinate_to_index(indices[:x])+ delta_x *
                          @meta_data.domain_x.step).round(3)
        coordinates[:y] = (@meta_data.domain_y.
                          get_coordinate_to_index(indices[:y])+ delta_y *
                          @meta_data.domain_y.step).round(3)
        return coordinates
      end

      # singleton method to check if the provided coordinate lies within
      # the given domain of the dataset
      # @param [DataDomain] data_domain domain of the {MetaData::VisMetaData}
      #   corresponding to the coordinate
      # @param [DataPoint] coordinate component of the coordinate to check
      # @return [Boolean] true, if in dataset, false: if not
      def self.coordinate_in_dataset(data_domain, coordinate)
        (coordinate <= data_domain.upper && coordinate >= data_domain.lower)
      end

      # singleton method to get the index to the next down rounded datapoint
      # @param [DataDomain] data_domain domain of the {MetaData::VisMetaData}
      #   corresponding to the coordinate
      # @param [DataPoint] coordinate component of the coordinate to check
      # @return [Numeric] the index of the next coordinate value (rounded down)
      def self.get_index_to_next_lower_datapoint(data_domain, coordinate)
        ((coordinate - data_domain.lower) / data_domain.step).floor
      end

      # singleton method to calculate the necessary boundary points
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Hash] the data points that will be used for the interpolation
      def self.calculate_boundary_datapoints(x, y)
        boundary = Hash.new()

        #getting boundary data points
        boundary[:d_xy] = create_data_point(  0, 0, x, y)
        boundary[:d_x1y] = create_data_point( 1, 0, x, y)
        boundary[:d_xy1] = create_data_point( 0, 1, x, y)
        boundary[:d_x1y1] = create_data_point(1, 1, x, y)

        return boundary
      end

      # singleton method to calculate the result of the bilinear interpolation
      # @param [Float] r the interpolation factor in x
      # @param [Float] s the interpolation factor in y
      # @param [Float] value the data value for this factors
      # @return [Float] the result of the product of the variables
      def self.calculate_interpolation_result(r, s, value)
        r * s * value
      end

      # singleton method to check if the provided coordinates lie on one of the
      # upper dimension boundaries
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Boolean] true: if upper boundary, false: if not
      def self.check_for_upper_boundary(x, y)
        return (x == @meta_data.domain_x.upper ||
                y == @meta_data.domain_y.upper)
      end

      # singleton method to apply the interpolation on a boundary case
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the interpolated value
      def self.boundary_case(x, y)
        if (x == @meta_data.domain_x.upper && y == @meta_data.domain_y.upper)
          return get_upper_boundary(x,y)
        end

        return LinearInterpolation.
               linear_interpolation(create_data_point(0, 0, x, y),
                      create_upper_data_point(@meta_data.domain_x, x, y), x, y)
      end

      # method to create the upper data point based on the given boundary
      # @param [DataDomain] domain the domain in x dimension
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [DataPoint] the generated data point
      def self.create_upper_data_point(domain, x, y)
        if (x == domain.upper)
          create_data_point(0, 1, x, y) # vertical case
        else
          create_data_point(1, 0, x, y) # horizontal case
        end
      end

      # singleton method to serve the case that a boundary point os requested
      # @param [Float] x x-coordinate of the interpolation point
      # @param [Float] y y-coordinate of the interpolation point
      # @return [Float] the interpolated value
      def self.get_upper_boundary(x,y)
        indices = get_data_indices(x, y)
        @data_set.data[indices[:y]][indices[:x]]
      end

    end

  end

end
