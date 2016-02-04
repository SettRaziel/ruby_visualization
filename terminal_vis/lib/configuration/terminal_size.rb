# @Author: Benjamin Held
# @Date:   2016-01-18 13:03:35
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-04 15:20:50

module TerminalSize

  class TerminalSize
    attr_reader :columns
    attr_reader :lines

    def initialize
      read_terminal_size()
    end

    def read_terminal_size
      values = detect_terminal_size()
      if (values != nil)
        @columns = values[0]
        @lines = values[1]
      else
        raise NoMethodError, ' Error: terminal size cannot be retrieved on' \
                             ' this system'.red
      end
    end

    private

    def detect_terminal_size
      # take informations directly from ENV variable
      if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
        [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
      # take informations from tput command
      elsif ((RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) &&
              command_exists?('tput'))
        [`tput cols`.to_i, `tput lines`.to_i]
      # take informations from stty command
      elsif STDIN.tty? && command_exists?('stty')
        `stty size`.scan(/\d+/).map { |s| s.to_i }.reverse
      else
        nil
      end
    rescue Exception
      puts ' Error: could not determine correct terminal size'.red
      nil
    end

    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? {|d|
        File.exist?(File.join(d, command))
      }
    end

  end

end
