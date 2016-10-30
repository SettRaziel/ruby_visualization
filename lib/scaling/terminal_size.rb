# @Author: Benjamin Held
# @Date:   2016-01-18 13:03:35
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-10-30 10:23:41

# module for classes and methods that determine the actual dimension of the
# terminal executing the script
module TerminalSize

  # class to extract the terminal dimension of the the terminal which called
  # the executing script
  class TerminalSize
    # @return [Integer] the number of lines of the used terminal
    attr_reader :columns
    # @return [Integer] the number of fields per row of the used terminal
    attr_reader :lines

    # initialization
    def initialize
      read_terminal_size
    end

    # method to determine the terminal dimension
    def read_terminal_size
      values = detect_terminal_size
      if (values != nil)
        @columns = values[0]
        @lines = values[1]
      else
        raise NoMethodError, ' Error: terminal size cannot be retrieved on' \
                             ' this system'.red
      end
    end

    private

    # method to read the terminal dimension, using different shell programs
    # @return [Array] the read values for the terminal dimension
    def detect_terminal_size
      # take informations directly from ENV variable
      if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
        [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
      # take informations from tput command
      elsif ((RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) &&
              command_exists?('tput'))
        [`tput cols`.to_i, `tput lines`.to_i]
      # take informations from stty command
      elsif (STDIN.tty? && command_exists?('stty'))
        `stty size`.scan(/\d+/).map { |s| s.to_i }.reverse
      else
        nil
      end
    rescue StandardError
      puts ' Error: could not determine correct terminal size'.red
      nil
    end

    # method to check if the given command can be executed
    # @param [String] command the provided command string
    # @return [Boolean] true: command can be used, false if not
    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? { |d|
        File.exist?(File.join(d, command))
      }
    end

  end

end
