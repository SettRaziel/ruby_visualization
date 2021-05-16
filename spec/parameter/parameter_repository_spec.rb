require "spec_helper"
require_relative "../../lib/parameter/parameter"

describe TerminalVis::Parameter::ParameterRepository do

  describe ".new" do
    context "given the one element all flag" do
      it "create the repository with the correct flags" do
        arguments = ["-a", "1", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:all]).to eq("1")
      end
    end
  end

  describe ".new" do
    context "given the one element all flag" do
      it "create the repository with the correct flags" do
        arguments = ["--all", "42", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:all]).to eq("42")
      end
    end
  end

  describe ".new" do
    context "given the two element coordinate flag" do
      it "create the repository with the correct flags" do
        arguments = ["-c", "21", "42", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:coord]).to eq(["21", "42"])
      end
    end
  end

  describe ".new" do
    context "given the two element coordinate flag" do
      it "create the repository with the correct flags" do
        arguments = ["--coord", "21", "42", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:coord]).to eq(["21", "42"])
      end
    end
  end

  describe ".new" do
    context "given the two element delta flag" do
      it "create the repository with the correct flags" do
        arguments = ["-d", "29", "91", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:delta]).to eq(["29", "91"])
      end
    end
  end

  describe ".new" do
    context "given the two element delta flag" do
      it "create the repository with the correct flags" do
        arguments = ["--delta", "29", "91", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:delta]).to eq(["29", "91"])
      end
    end
  end

  describe ".new" do
    context "given the boolean extreme flag" do
      it "create the repository with the correct flags" do
        arguments = ["-e", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:extreme]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the boolean extreme flag" do
      it "create the repository with the correct flags" do
        arguments = ["--extreme", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:extreme]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the one element index flag" do
      it "create the repository with the correct flags" do
        arguments = ["-i", "29", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:index]).to eq("29")
      end
    end
  end

  describe ".new" do
    context "given the one element index flag" do
      it "create the repository with the correct flags" do
        arguments = ["--index", "6", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:index]).to eq("6")
      end
    end
  end

  describe ".new" do
    context "given the boolean meta flag" do
      it "create the repository with the correct flags" do
        arguments = ["-m", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:meta]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the boolean meta flag" do
      it "create the repository with the correct flags" do
        arguments = ["--meta", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:meta]).to eq(true)
      end
    end
  end  

  describe ".new" do
    context "given the one element option flag" do
      it "create the repository with the correct flags" do
        arguments = ["-o", "option_file", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:option]).to eq("option_file")
      end
    end
  end

  describe ".new" do
    context "given the one element option flag" do
      it "create the repository with the correct flags" do
        arguments = ["--option", "option_file", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:option]).to eq("option_file")
      end
    end
  end

  describe ".new" do
    context "given the two element range flag" do
      it "create the repository with the correct flags" do
        arguments = ["-r", "6", "29", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:range]).to eq(["6", "29"])
      end
    end
  end

  describe ".new" do
    context "given the two element range flag" do
      it "create the repository with the correct flags" do
        arguments = ["--range", "6", "91", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:range]).to eq(["6", "91"])
      end
    end
  end

  describe ".new" do
    context "given the two element section flag" do
      it "create the repository with the correct flags" do
        arguments = ["-s", "11", "21", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:section]).to eq(["11", "21"])
      end
    end
  end

  describe ".new" do
    context "given the two element section flag" do
      it "create the repository with the correct flags" do
        arguments = ["--section", "21", "85", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:section]).to eq(["21", "85"])
      end
    end
  end

  describe ".new" do
    context "given the two element time flag" do
      it "create the repository with the correct flags" do
        arguments = ["-t", "6", "29", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:time]).to eq(["6", "29"])
      end
    end
  end

  describe ".new" do
    context "given the two element time flag" do
      it "create the repository with the correct flags" do
        arguments = ["--time", "1", "29", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:time]).to eq(["1", "29"])
      end
    end
  end

  describe ".new" do
    context "given no arguments for the initialization" do
      it "raise an argument error" do
        arguments = [ ]
        expect { 
          TerminalVis::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given an invalid parameter" do
      it "raise an argument error" do
        arguments = ["test", "-f", "filename"]
        expect { 
          TerminalVis::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given an invalid parameter" do
      it "raise an argument error" do
        arguments = ["-1", "--file", "filename"]
        expect { 
          TerminalVis::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given an invalid parameter" do
      it "raise an argument error" do
        arguments = ["--error", "-f", "filename"]
        expect { 
          TerminalVis::Parameter::ParameterRepository.new(arguments)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".new" do
    context "given the version flag as parameter" do
      it "set the flag for version output" do
        arguments = ["-v", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:version]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the version flag as parameter" do
      it "set the flag for version output" do
        arguments = ["--version", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:version]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the help flag as parameter" do
      it "set the flag for help output" do
        arguments = ["-h", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:help]).to eq(true)
      end
    end
  end

  describe ".new" do
    context "given the help flag with the date parameter" do
      it "set the flag for help output with the date" do
        arguments = ["-a", "-h", "--file", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:help]).to eq(:all)
      end
    end
  end

  describe ".new" do
    context "given the help flag with the date parameter" do
      it "set the flag for help output with the date" do
        arguments = ["--all", "--help", "-f", "filename"]
        parameter_repository = TerminalVis::Parameter::ParameterRepository.new(arguments)
        expect(parameter_repository.parameters[:help]).to eq(:all)
      end
    end
  end

end
