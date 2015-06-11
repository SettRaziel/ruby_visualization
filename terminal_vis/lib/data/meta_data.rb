# @Author: Benjamin Held
# @Date:   2015-06-09 12:49:43
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-11 20:33:26

class MetaData
    attr_reader :name, :domain_x, :domain_y, :domain_z

    def initialize(metadata)

        raise IndexError if meta.length != 12

        @name = metadata[8]
        @domain_x = DataDomain.new(metadata[0], metadata[1], \
                                   metadata[2], metadata[3])
        @domain_y = DataDomain.new(metadata[4], metadata[5], \
                                   metadata[6], metadata[7])
        @domain_z = DataDomain.new(metadata[8], metadata[9], \
                                   metadata[10], metadata[11])
    end
end

class DataDomain
    attr_reader :name, :lower, :upper, :step

    def initialize(name, lower, upper, step)
        @name = name
        @lower = lower
        @upper = upper
        @step = step
    end

end
