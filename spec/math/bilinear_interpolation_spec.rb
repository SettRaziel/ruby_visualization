require "spec_helper"

describe TerminalVis::Interpolation::BilinearInterpolation do

  describe "#bilinear_interpolation" do
    context "given a data set, meta data and a coordinate" do
      it "calculate the bilinear interpolation for the given coordinate" do
        data = Array.new()
        data << [5.0,4.0,3.0,2.0]
        data << [4.0,4.0,3.0,2.0]
        data << [3.0,3.0,3.0,2.0]
        data << [2.0,2.0,2.0,1.0]
        data << [2.0,2.0,1.0,0.0]
        arguments = ["meta_title", "X", 0, 3, 1, "Y", 0, 3, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)

        value = TerminalVis::Interpolation::BilinearInterpolation.
        bilinear_interpolation(meta_data, DataInput::DataSet.new(data), 1.5, 2.5)
        expect(value).to eq(2.5)
      end
    end
  end

end
