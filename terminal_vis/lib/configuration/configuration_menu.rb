# @Author: Benjamin Held
# @Date:   2015-10-21 15:11:07
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-21 22:19:17

require_relative '../main/main_module'

class ConfigurationMenu

  # public entry point for the configuration menu
  def self.print_menu
    is_finished = false;

    while(!is_finished)
      puts "Configuration Menu. Select parameter:"
      puts "(1) Extended data legend."
      puts "(2) Determine y-resolution for timeline."
      puts "(3) Exit."
      is_finished = process_input(get_entry("Input (1-3): ").to_i)
    end
  end

  private

  # method to check the input and proceed depending on its value
  # @param [Integer] input the provided input
  # @return [boolean] as an indicator if the configuration is finished
  def self.process_input(input)
    case input
      when 1
        process_legend_input(get_entry("Input value (0: false, 1:true) : ")
                             .to_i)
      when 2 then process_ydim_input(get_entry("Input value: ").to_i)
      when 3 then return true
    else
      print_error("Error: Input is not valid.")
    end
  end

  # method to process the parameter for the extended legend option
  # @param [Integer] input the provided parameter
  def self.process_legend_input(input)
    if (input == 0)
    TerminalVis::option_handler.options.change_option(:legend_extend, false)
    elsif (input != 0)
    TerminalVis::option_handler.options.change_option(:legend_extend, true)
    end
  end

  # method to process the parameter for the y dimension option
  # @param [Integer] input the provided parameter
  def self.process_ydim_input(input)
    TerminalVis::option_handler.options.change_option(:y_time_size, input)
  end

  # method to print a message and read the following input
  # @param [String] message prompt message
  # @return [String] the provided input
  def self.get_entry(message)
    print message
    gets.chomp
  end

end
