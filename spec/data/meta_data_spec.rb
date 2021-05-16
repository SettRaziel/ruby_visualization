require "spec_helper"
require_relative "../../lib/data/meta_data"

describe TerminalVis::MetaData::VisMetaData do

  describe ".new" do
    context "given a meta data array" do
      it "create the meta data object with the given title" do
        arguments = ["meta_title", "X", 0, 10, 1, "Y", 0, 21, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)
        expect(meta_data.name).to eq("meta_title")
      end
    end
  end

  describe ".new" do
    context "given a meta data array" do
      it "create the meta data object with the given x domain" do
        arguments = ["meta_title", "X", 0, 10, 1, "Y", 0, 21, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)
        expect(meta_data.domain_x.name).to eq("X")
        expect(meta_data.domain_x.lower).to eq(0)
        expect(meta_data.domain_x.upper).to eq(10)
        expect(meta_data.domain_x.step).to eq(1)
      end
    end
  end

  describe ".new" do
    context "given a meta data array" do
      it "create the meta data object with the given y domain" do
        arguments = ["meta_title", "X", 0, 10, 1, "Y", 0, 21, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)
        expect(meta_data.domain_y.name).to eq("Y")
        expect(meta_data.domain_y.lower).to eq(0)
        expect(meta_data.domain_y.upper).to eq(21)
        expect(meta_data.domain_y.step).to eq(1)
      end
    end
  end

  describe ".new" do
    context "given a meta data array" do
      it "create the meta data object with z domain as nil" do
        arguments = ["meta_title", "X", 0, 10, 1, "Y", 0, 21, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)
        expect(meta_data.domain_z).to be_nil
      end
    end
  end

  describe ".new" do
    context "given a meta data array" do
      it "create the meta data object with z domain as nil" do
        arguments = ["meta_title", "X", 0, 10, 1, "Y", 0, 21, 1, "Z", 1, 5, 1]
        meta_data = TerminalVis::MetaData::VisMetaData.new(arguments)
        expect(meta_data.domain_z.name).to eq("Z")
        expect(meta_data.domain_z.lower).to eq(1)
        expect(meta_data.domain_z.upper).to eq(5)
        expect(meta_data.domain_z.step).to eq(1)
      end
    end
  end

  describe ".new" do
    context "given a meta data array" do
      it "create the meta data object with z domain as nil" do
        arguments = ["meta_title", "X", 0, 10, 1, "Y", 0, 21, 1, "Z", 1, 5]
        expect {
        TerminalVis::MetaData::VisMetaData.new(arguments)
        }.to raise_error(IndexError)
      end
    end
  end

end
