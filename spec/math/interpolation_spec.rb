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

  describe "#interpolate_for_coordinate" do
    context "given a data set, meta data and a coordinate" do
      it "calculate the bilinear interpolation for the given coordinate" do
        data = Array.new()
        data << [5.0,4.0,3.0,2.0]
        data << [4.0,4.0,3.0,2.0]
        data << [3.0,3.0,3.0,2.0]
        data << [2.0,2.0,1.0,1.0]
        data << [2.0,2.0,1.0,0.0]
        arguments = ["meta_title", "X", 0, 3, 1, "Y", 0, 3, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)

        value = TerminalVis::Interpolation.
        interpolate_for_coordinate(meta_data, {:x => 1.5, :y => 2.5 }, DataInput::DataSet.new(data))
        expect(value).to eq(2.25)
      end
    end
  end

end
