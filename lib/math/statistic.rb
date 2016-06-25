# @Author: Benjamin Held
# @Date:   2016-04-24 18:33:55
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-27 18:52:11

# This module holds methods to apply statistical functions of the provided data
module Statistic

  # method to calculate the arithmetic mean values of the given data
  # @param [Array] data a list of values that have a natural order and can
  #   determine a mean value
  # @return [Float] the mean value of the input data
  def self.mean_value(data)
    mean = 0.0
    data.each { |value|
      mean += value
    }
    return mean / data.length
  end

end
