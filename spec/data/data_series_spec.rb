require "spec_helper"

describe DataInput::DataSeries do

  describe ".add_data_set" do
    context "given a set of data values" do
      it "create the data series object with the given values" do

        data_series = DataInput::DataSeries.new()
        data_series.add_data_set(DataInput::DataSet.new([[5.0,5.0],[5.0,5.0]]))
        data_series.add_data_set(DataInput::DataSet.new([[4.0,4.0],[4.0,4.0]]))
        data_series.add_data_set(DataInput::DataSet.new([[3.0,3.0],[3.0,3.0]]))
        data_series.add_data_set(DataInput::DataSet.new([[2.0,2.0],[2.0,2.0]]))
        data_series.add_data_set(DataInput::DataSet.new([[1.0,1.0],[1.0,1.0]]))

        expect(data_series.min_value).to eq(1)
        expect(data_series.max_value).to eq(5)
        expect(data_series.series[0].data[0][1]).to eq(5)
        expect(data_series.series[3].data[1][1]).to eq(2)
      end
    end
  end

end
