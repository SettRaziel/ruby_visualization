require "spec_helper"

describe TerminalVis do

  describe "#print_version" do
    context "given the main module" do
      it "print the correct version information" do
        expect { 
          TerminalVis.print_version
        }.to output("terminal_visualization version 0.9.2".yellow + "\n" + \
                    "Created by Benjamin Held (June 2015)".yellow + "\n").to_stdout
      end
    end
  end

end
