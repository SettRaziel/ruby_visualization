require "spec_helper"

describe DataInput::DataSet do

  describe ".new" do
    context "given an array with data values" do
      it "create the data set object with the given values" do
        data = Array.new()
        data << [5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0,5.0]
        data << [3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0,3.0]
        data << [2.0,4.0,2.0,2.0,2.0,4.0,2.0,4.0,2.0,4.0,2.0,4.0,2.0,2.0,4.0,2.0,2.0]
        data << [1.0,4.0,1.0,1.0,1.0,4.0,1.0,4.0,1.0,4.0,1.0,4.0,1.0,4.0,1.0,4.0,1.0]
        data << [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

        data_set = DataInput::DataSet.new(data)
        expect(data_set.min_value).to eq(0)
        expect(data_set.max_value).to eq(5)
        expect(data_set.data[2][9]).to eq(4)
        expect(data_set.data[0][6]).to eq(5)
      end
    end
  end

  describe ".new" do
    context "given an array with data values" do
      it "raise an ArgumentError for the nil value in the data array" do
        data = [5.0,nil]
        expect {
          DataInput::DataSet.new(data)
        }.to raise_error(ArgumentError)
      end
    end
  end

end
