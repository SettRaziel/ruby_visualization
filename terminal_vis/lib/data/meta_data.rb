# @Author: Benjamin Held
# @Date:   2015-06-09 12:49:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-16 17:08:15

# MetaData stores meta information about the data set
# two dimensional data set =>
# <data_name>,
# <axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,
# <axis_description_y>,<lower_boundary_y>,<upper_boundary_y>
#
# three dimensional data set =>
# <data_name>,
# <axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,
# <axis_description_y>,<lower_boundary_y>,<upper_boundary_y>,
# <axis_description_z>,<lower_boundary_z>,<upper_boundary_z>
class MetaData
    attr_reader :name, :domain_x, :domain_y, :domain_z

    def initialize(metadata)

        if (metadata.length != 13 || metadata.length != 9)
            STDERR.puts "Error in meta data: incorrect number of arguments:" \
            " #{metadata.length}."
            exit(0)
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

class DataDomain
    attr_reader :name, :lower, :upper, :step

    def initialize(name, lower, upper, step)
        @name = name
        begin
            @lower = Float(lower)
            @upper = Float(upper)
            @step = Float(step)
        rescue ArgumentError => e
            STDERR.puts "Error in meta data: non number argument."
        end
    end

end
