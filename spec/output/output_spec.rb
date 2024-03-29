require "spec_helper"

describe TerminalVis::Output do

  describe "#create_output" do
    context "given input parameters and a file" do
      it "read the data and create to correct visual output" do
        TerminalVis::initialize_repositories(["--file", "./spec/files/test_data"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_output"))
        expect { 
          TerminalVis::Output.create_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

  describe "#create_output" do
    context "given input parameters and a file" do
      it "read the data and create to correct visual output with extreme values" do
        TerminalVis::initialize_repositories(["-e", "--file", "./spec/files/test_data"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_extreme"))
        expect { 
          TerminalVis::Output.create_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

  describe "#create_output" do
    context "given input parameters and a file with meta data" do
      it "read the data and create to correct visual output for the second dataset with meta data" do
        TerminalVis::initialize_repositories(["-m", "-i", "1", "--file", "./spec/files/test_small_meta"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_meta"))
        expect { 
          TerminalVis::Output.create_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

  describe "#create_delta_output" do
    context "given input parameters and a file with meta data" do
      it "read the data and create to correct visual output for the delta data with meta data" do
        TerminalVis::initialize_repositories(["-m", "-d", "1", "2", "--file", "./spec/files/test_small_meta"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_diff"))
        expect { 
          TerminalVis::Output.create_delta_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

  describe "#create_timeline" do
    context "given input parameters and a file with meta data" do
      it "read the data and create to correct visual output for the timeline with meta data" do
        TerminalVis::initialize_repositories(["-m", "-t", "1", "1", "--file", "./spec/files/test_small_meta"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_timeline"))
        expect { 
          TerminalVis::Output.create_timeline(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

  describe "#create_region_interpolation_output" do
    context "given input parameters and a file with meta data" do
      it "read the data and create to correct visual output for the region with meta data" do
        TerminalVis::initialize_repositories(["-m", "-i", "1", "-c", "2", "2", "-s", "1", "0.1", "--file", "./spec/files/test_small_meta"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_region"))
        expect { 
          TerminalVis::Output.create_region_interpolation_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

  describe "#create_interpolation_output" do
    context "given input parameters and a file with meta data" do
      it "read the data and create to correct visual output for the interpolation with meta data" do
        TerminalVis::initialize_repositories(["-m", "-i", "1", "-c", "2.5", "2.5", "--file", "./spec/files/test_small_meta"])
        TerminalVis.determine_configuration_options
        meta_data = TerminalVis.create_metadata()
        input = File.read(File.join(DATA_ROOT,"create_interpolation"))
        expect { 
          TerminalVis::Output.create_interpolation_output(meta_data)
        }.to output(input).to_stdout
                    
      end
    end
  end

end
