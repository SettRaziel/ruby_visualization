require "spec_helper"

describe TerminalVis::Output do

  describe "#create_output" do
    context "given an array with data values" do
      it "create the data set object with the given values" do
        TerminalVis::initialize_repositories(["--file", "./spec/files/test_data"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_output"))
        puts input.inspect
        expect { 
          TerminalVis::Output.create_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

end
