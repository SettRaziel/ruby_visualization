require "spec_helper"
require_relative "../../lib/data/meta_data"

describe TerminalVis::MetaData::DataDomain do

  describe ".new" do
    context "given a data domain object" do
      it "create the data domain object with the given values" do
        data_domain = TerminalVis::MetaData::DataDomain.new("X", 0, 10, 2)
        expect(data_domain.name).to eq("X")
        expect(data_domain.lower).to eq(0)
        expect(data_domain.upper).to eq(10)
        expect(data_domain.step).to eq(2)
      end
    end
  end

  describe ".new" do
    context "given a data domain object" do
      it "create the data domain object with the given values" do
        data_domain = TerminalVis::MetaData::DataDomain.new("X", "0", "10", "2")
        expect(data_domain.name).to eq("X")
        expect(data_domain.lower).to eq(0)
        expect(data_domain.upper).to eq(10)
        expect(data_domain.step).to eq(2)
      end
    end
  end

  describe ".new" do
    context "given a data domain object" do
      it "fail to create the data domain object with the given values" do
        expect {
          TerminalVis::MetaData::DataDomain.new("X", 0, 10, "abc")
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given a data domain object" do
      it "fail to create the data domain object with the given values" do
        expect {
          TerminalVis::MetaData::DataDomain.new("X", "abc", 0, 10)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given a data domain object" do
      it "fail to create the data domain object with the given values" do
        expect {
          TerminalVis::MetaData::DataDomain.new("X", 0, "abc", 10)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".get_coordinate_to_index" do
    context "given a data domain object" do
      it "give an index and return the coordinate" do
        data_domain = TerminalVis::MetaData::DataDomain.new("X", "0", "10", "2")
        expect(data_domain.get_coordinate_to_index(2)).to eq(4)
      end
    end
  end

  describe ".get_coordinate_to_index" do
    context "given a data domain object" do
      it "give an index and return the coordinate" do
        data_domain = TerminalVis::MetaData::DataDomain.new("X", "0", "10", "2")
        expect(data_domain.get_coordinate_to_index(5)).to eq(10)
      end
    end
  end

  describe ".get_coordinate_to_index" do
    context "given a data domain object" do
      it "give an index out of the boundary and fail the index check" do
        data_domain = TerminalVis::MetaData::DataDomain.new("X", "0", "10", "2")
        expect {
          data_domain.get_coordinate_to_index(6)
        }.to raise_error(RangeError)
      end
    end
  end

  describe ".get_coordinate_to_index" do
    context "given a data domain object" do
      it "give an index out of the boundary and fail the index check" do
        data_domain = TerminalVis::MetaData::DataDomain.new("X", "0", "10", "2")
        expect {
          data_domain.get_coordinate_to_index(-1)
        }.to raise_error(RangeError)
      end
    end
  end

end
