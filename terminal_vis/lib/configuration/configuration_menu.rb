# @Author: Benjamin Held
# @Date:   2015-10-21 15:11:07
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-11-04 19:54:36

require_relative '../main/main_module'

# singleton class to deliver a simple terminal menu to provide values for the
# available configuration parameter
class ConfigurationMenu

  # public entry point for the configuration menu
  def self.print_menu
    is_running = true
     # necessary to clear the script parameter, which has already been
     # processed by the parameter_repository
    ARGF.argv.clear

    while(is_running)
      puts "Configuration Menu. Select parameter:"
      puts "(1) Extended data legend."
      puts "(2) Determine y-resolution for timeline."
      puts "(3) Save parameters to file."
      puts "(4) Exit."
      is_running = process_input(get_entry("Input (1-4): ").to_i)
    end
  end

  private

  # method to check the input and proceed depending on its value
  # @param [Integer] input the provided input
  # @return [boolean] as an indicator if the configuration is finished
  def self.process_input(input)
    case input
      when 1 then return process_legend_input(
                         get_entry("Input value (0: false, 1:true) : ").to_i)
      when 2 then return process_ydim_input(get_entry("Input value: ").to_i)
      when 3 then return save_to_file(get_entry("Save destination: "))
      when 4 then return false
    else
      print_error("Error: Input is not valid.")
    end
  end

  # method to process the parameter for the extended legend option
  # @param [Integer] input the provided parameter
  # @return [boolean] true if the parameter was processed correctly
  def self.process_legend_input(input)
    if (input == 0)
    TerminalVis::option_handler.options.change_option(:legend_extend, false)
    elsif (input != 0)
    TerminalVis::option_handler.options.change_option(:legend_extend, true)
    end
    return true
  end

  # method to process the parameter for the y dimension option
  # @param [Integer] input the provided parameter
  # @return [boolean] true if the parameter was processed correctly
  def self.process_ydim_input(input)
    TerminalVis::option_handler.options.change_option(:y_time_size, input)
    return true
  end

  # method to save the currently defined options to a file
  # @param [String] filename the filename of the output file
  # @return [boolean] true if the options were saved correctly
  def self.save_to_file(filename)
    TerminalVis::option_handler.save_options(filename)
    puts "Saved options to #{filename}"
    return true
  end

  # method to print a message and read the following input
  # @param [String] message prompt message
  # @return [String] the provided input
  def self.get_entry(message)
    print message
    gets.chomp
  end

end
