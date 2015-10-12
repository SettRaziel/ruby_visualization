# @Author: Benjamin Held
# @Date:   2015-10-10 19:56:37
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-12 18:40:44

require_relative '../data/file_reader'
require_relative './configuration_repository'

class ConfigurationHandler
  # @return [ConfigurationRepository] repository with the configuration
  #   parameters
  attr_reader :options

  # initialization
  # @param [String] filename the provided filename for the options
  def initialize(filename=nil)
    initialize_option_mapping
    if (filename == nil)
      @options = ConfigurationRepository.new()
    else
      check_and_read_options(filename)
    end
  end

  private
  # @return [Hash] mapping of String => Symbol for reading options from
  #   a file
  attr :option_mapping

  # method to initialize the Hash with the mapping String => Symbol
  def initialize_option_mapping
    @option_mapping = Hash.new()
    @option_mapping["legend_extend"]= :legend_extend
    @option_mapping["y_time_size"]= :y_time_size
  end

  # method to check the given filename and read the options when it is a valid
  # file
  # @param [String] filename the provided filename
  def check_and_read_options(filename)
    check_for_valid_filepath(filename)

    read_options(filename)
  end

  # checks if the parsed filename is a valid unix or windows file name
  # @param [String] filepath the provided filepath
  # @raise [ArgumentError] if filepath is not valid
  def check_for_valid_filepath(filepath)
    unixfile_regex= %r{
      \A                       # start of string
      ((\.\/)|(\.\.\/)+|(\/))? # relativ path or upwards or absolute
      ([\-\w\s]+\/)*           # 0-n subsirectories
      [\-\w\s]*[a-zA-Z0-9]     # filename
      (\.[a-zA-Z0-9]+)?        # extension
      \z                       # end of string
    }x

    windowsfile_regex = %r{
      \A                      # start of string
      ([A-Z]:)?\\?            # device name
      ([\-\w\s]+\\)*          # directories
      [\-\w\s]*[a-zA-Z0-9]    # filename
      (\.[a-zA-Z0-9]+)?       # extension
      \z                      # end of string
    }x

    if (!(filepath =~ unixfile_regex || filepath =~ windowsfile_regex))
      raise ArgumentError, " Error: invalid filepath: #{filepath}"
    end
  end

  # method to read the configuration options from a file
  # @param [String] filename the path of the file
  def read_options(filename)
    settings = Hash.new()
    FileReader.new(filename, ';').data.each { |line|
      type = Object.const_get(line[1])
      settings[@option_mapping[line[0]]] = determine_value(type, line[2])
    }
    @options = ConfigurationRepository.new(settings)
  end

  # method to determine the type of the value and return an object with the
  # class of the intended value
  # @param [Class] type the required class
  # @param [String] value to string containing the required value
  # @return [Object] the value cast in the intended class
  def determine_value(type, value)
    return false if (type == FalseClass)
    return true  if (type == TrueClass)
    return value.to_i if (type == Integer)
    return value.to_f if (type == Float)
    value
  end

end
