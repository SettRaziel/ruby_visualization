require "spec_helper"

describe TerminalVis::Interpolation do

  describe "#linear_interpolation_for_coordinate" do
    context "given two data point and a coordinate" do
      it "calculate the linear interpolation for the given coordinate" do

        data_point_1 = TerminalVis::Interpolation::DataPoint.new(1,1,2.0)
        data_point_2 = TerminalVis::Interpolation::DataPoint.new(2,2,3.0)
        value = TerminalVis::Interpolation.
                             linear_interpolation_for_coordinate(data_point_1, data_point_2, 1.25, 1.25)

        expect(value).to eq(2.25)
      end
    end
  end

end
