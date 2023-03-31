require "spec_helper"
require_relative "../../lib/parameter/parameter"

describe TerminalVis::Parameter::ParameterHandler do

  describe ".new" do
    context "given the date flag" do
      it "create the repository and pass the parameter contrains" do
        arguments = ["-a", "29", "--file", "filename"]
        parameter_handler = TerminalVis::Parameter::ParameterHandler.new(arguments)
        expect(parameter_handler.repository.parameters[:all]).to eq("29")
      end
    end
  end

  describe ".new" do
    context "given the all and delta flag" do
      it "create the repository and fail the parameter contrains of -a and -d" do
        arguments = ["-a", "29", "-d", "6", "91", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the all and index flag" do
      it "create the repository and fail the parameter contrains of -a and -i" do
        arguments = ["-a", "29", "-i", "1", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the all and time flag" do
      it "create the repository and fail the parameter contrains of -a and -t" do
        arguments = ["-a", "29", "-t", "1", "85", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the range and time flag" do
      it "create the repository and fail the parameter contrains of -r and -t" do
        arguments = ["-r", "35", "85", "-t", "29", "91", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the range and index flag" do
      it "create the repository and fail the parameter contrains of -r and -i" do
        arguments = ["-r", "13", "37", "-i", "3", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the coordinate and extreme flag" do
      it "create the repository and fail the parameter contrains of -c and -e" do
        arguments = ["-c", "13", "37", "e", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the coordinate and time flag" do
      it "create the repository and fail the parameter contrains of -c and -t" do
        arguments = ["-c", "13", "37", "-t", "42", "21", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the delta and index flag" do
      it "create the repository and fail the parameter contrains of -d and -i" do
        arguments = ["-d", "13", "37", "-i", "3", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the delta and time flag" do
      it "create the repository and fail the parameter contrains of -d and -t" do
        arguments = ["-d", "13", "37", "-t", "42", "21", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the section flag" do
      it "create the repository and fail since the coordinate parameter is missing" do
        arguments = ["-s", "13", "37", "-f", "filename"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end    

  describe ".new" do
    context "given the all flag" do
      it "create the repository and fail the parameter contrains due to missing file" do
        arguments = ["-a", "29"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the all flag" do
      it "create the repository and fail the parameter contrains due to missing coordinates" do
        arguments = ["-m", "-i", "1", "-s", "1", "0.1", "-f", "./test_small_meta"]
        expect {
          TerminalVis::Parameter::ParameterHandler.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the all flag" do
      it "create the repository and pass the parameter contrains" do
        arguments = ["-m", "-i", "1", "-c", "2", "2", "-s", "1", "0.1", "-f", "./test_small_meta"]
        parameter_handler = TerminalVis::Parameter::ParameterHandler.new(arguments)
        expect(parameter_handler.repository.parameters[:coord]).to eq(["2","2"])
        expect(parameter_handler.repository.parameters[:section]).to eq(["1","0.1"])
      end
    end
  end

end
