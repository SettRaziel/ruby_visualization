# @Author: Benjamin Held
# @Date:   2015-10-21 15:11:07
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-08-19 16:59:30

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
      puts 'Configuration Menu. Select parameter:'.light_yellow
      puts '(1) Extended data legend.'
      puts '(2) Determine y-resolution for timeline.'
      puts '(3) Use scaled output.'
      puts '(4) Save parameters to file.'
      puts '(5) Exit.'
      is_running = process_input(get_entry('Input (1-5): '.blue.bright).to_i)
    end
  end

  private

  # method to check the input and proceed depending on its value
  # @param [Integer] input the provided input
  # @return [boolean] as an indicator if the configuration is finished
  def self.process_input(input)
    case input
      when 1 then return process_legend_input(
                         get_entry('Input value (0: false, 1:true) : ').to_i)
      when 2 then return process_ydim_input(get_entry('Input value: ').to_i)
      when 3 then return process_scale_input(
                         get_entry('Input value (0: false, 1:true) : ').to_i)
      when 4 then return save_to_file(get_entry('Save destination: '))
      when 5 then return false
    else
      puts ' Error: Input is not valid.'.red
      return true
    end
  end

  # method to process the parameter for the extended legend option
  # @param [Integer] input the provided parameter
  # @return [boolean] true if the parameter was processed correctly
  def self.process_legend_input(input)
    process_boolean_input(input, :legend_extend)
  end

  # method to process the parameter for the y dimension option
  # @param [Integer] input the provided parameter
  # @return [boolean] true if the parameter was processed correctly
  def self.process_ydim_input(input)
    begin
      check_dimension_value(input)
      TerminalVis::option_handler.options.change_option(:y_time_size, input)
    rescue ArgumentError => e
      puts e.message
    end
    return true
  end

  # checks if the input for the y-dimension lies within acceptable boundaries
  # @param [Integer] input the provided input
  # @raise [ArgumentError] if the value lies outside the interval
  def self.check_dimension_value(input)
    if (input <= 0 || input > 100)
      raise ArgumentError,
            " Error: y_dim value #{input} runs out of bound [1,100]".red
    end
  end

  # method to obtain the input for the scale option
  # @param [Integer] input the provided input
  # @return [Boolean] true to mark the successful handling of the input
  def self.process_scale_input(input)
    process_boolean_input(input, :auto_scale)
  end

  # method to precess the input for a boolean parameter
  # @param [Integer] input the provided input
  # @param [Symbol] symbol the hash key for the options menu
  # @return [Boolean] true to mark the successful handling of the input
  def self.process_boolean_input(input, symbol)
    case input
    when 0 then TerminalVis::option_handler.options.
                             change_option(symbol, false)
    when 1 then TerminalVis::option_handler.options.
                             change_option(symbol, true)
    else
      puts ' Error: Input is not valid.'.red
    end
    return true
  end

  # method to save the currently defined options to a file
  # @param [String] filename the filename of the output file
  # @return [boolean] true if the options were saved correctly
  def self.save_to_file(filename)
    begin
      TerminalVis::option_handler.save_options(filename)
      puts "Saved options to #{filename}".green
    rescue Exception => e
      puts ' Error while saving options: '.concat(e.message).red
    end
    return true
  end

  # method to print a message and read the following input
  # @param [String] message prompt message
  # @return [String] the provided input
  def self.get_entry(message)
    print message.blue.bright
    gets.chomp
  end

end
