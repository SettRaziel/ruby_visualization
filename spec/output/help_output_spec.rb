require "spec_helper"

describe HelpOutput do

  describe "#print_help_for" do
    context "given a simple help entry" do
      it "print the help text for :extreme" do
        expect { 
          HelpOutput.print_help_for(:extreme) 
        }.to output("TerminalVis help:".light_yellow + "\n" + \
                    " -e, --extreme  ".light_blue +  \
                    "marks the extreme values in a " + \
                    "dataset with ++ for a maximum and -- for a minimum, " + \
                    "also prints the coordinates of the extreme values below" + \
                    " the legend, excludes -c\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a simple help entry" do
      it "print the help text for :meta" do
        expect { 
          HelpOutput.print_help_for(:meta) 
        }.to output("TerminalVis help:".light_yellow + "\n" + \
                    " -m, --meta     ".light_blue +  \
                    "process the file <filename> containing meta data\n").to_stdout
      end
    end
  end

  describe "#print_help_for" do
    context "given a one element help entry" do
      it "print the help text for :all" do
        expect { 
          HelpOutput.print_help_for(:all) 
        }.to output("TerminalVis help:".light_yellow + "\n" + \
                    " -a, --all      ".light_blue + "argument:".red + " <speed>".yellow  + \
                    "; prints all specified datasets of a dataseries with a pause " + \
                    "between the output of every dataset defined by speed: 0 means " + \
                    "manual, a value > 0 an animation speed in seconds, excludes -i," + \
                    " -d and -t\n").to_stdout
      end
    end
  end 

end
