# @Author: Benjamin Held
# @Date:   2015-06-09 12:49:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-07-05 12:16:01

# MetaData stores meta information about the data set
# two dimensional data set =>
# @name => <data_name>,
# @domain_x => <axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,
# @domain_y => <axis_description_y>,<lower_boundary_y>,<upper_boundary_y>
# @domain_z => nil
#
# three dimensional data set =>
# @name => <data_name>,
# @domain_x => <axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,
# @domain_y => <axis_description_y>,<lower_boundary_y>,<upper_boundary_y>,
# @domain_z => <axis_description_z>,<lower_boundary_z>,<upper_boundary_z>
# raises IndexError when parameter metadata has not the correct size
class MetaData
    attr_reader :name, :domain_x, :domain_y, :domain_z

    # raises IndexError when parameter metadata has not the correct size
    def initialize(metadata)

        if !(metadata.length == 13 || metadata.length == 9)
            raise IndexError, "Error in meta data: incorrect number of" \
                              " arguments: #{metadata.length}."
        end

        @name = metadata[0]
        @domain_x = DataDomain.new(metadata[1], metadata[2], \
                                   metadata[3], metadata[4])
        @domain_y = DataDomain.new(metadata[5], metadata[6], \
                                   metadata[7], metadata[8])

        if (metadata.length == 13)
            @domain_z = DataDomain.new(metadata[9], metadata[10], \
                                       metadata[11], metadata[12])
        else
            @domain_z = nil
        end
    end
end

# DataDomain represents the meta data for one dimension
# @name => name of the data
# @lower => lower boundary of the dimension
# @upper => upper boundary of the dimension
# @step => step range between two values
# raises ArgumentError if parsing of attribute values fails
class DataDomain
    attr_reader :name, :lower, :upper, :step

    def initialize(name, lower, upper, step)
        @name = name
        begin
            @lower = Float(lower)
            @upper = Float(upper)
            @step = Float(step)
        rescue ArgumentError => e
            raise ArgumentError, "Error in data domain: non number argument."
        end
    end

end
