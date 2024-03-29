module TerminalVis

  require_relative "../data/data_input"
  require_relative "../parameter/parameter"
  require_relative "../configuration/configuration_handler"
  require_relative "../output/help_output"
  require_relative "../output/output"
  require_relative "../output/parameter_collector"
  require_relative "../math/interpolation"

  # Dummy class to get access to the instance variables
  class << self
    # @return [DataRepository] the repository storing the datasets
    attr_reader :data_repo
    # @return [Parameter::ParameterHandler] the handler controlling
    #   the parameters
    attr_reader :parameter_handler
    # @return [Configuration_Handler] the handler controlling the
    #   configuration parameter
    attr_reader :option_handler
  end

  # singleton method to initialize the required repositories
  # @param [Array] arguments the input values from the terminal input ARGV
  def self.initialize_repositories(arguments)
      @parameter_handler = Parameter::ParameterHandler.new(arguments)
      @data_repo = DataInput::DataRepository.new()
      @option_handler = ConfigurationHandler.new()
  end

  # creates the {MetaData::VisMetaData} based on the provided parameters
  # @return [VisMetaData] returns the meta data for the dataset
  def self.create_metadata
    begin
      if (@parameter_handler.repository.parameters[:meta])
        @data_repo.add_data(@parameter_handler.repository.parameters[:file])
      else
        @data_repo.add_data_with_default_meta(
                       @parameter_handler.repository.parameters[:file])
      end
    rescue StandardError => e
      print_error(" Error while creating metadata:\n ".concat(e.message))
    end
  end

  # method to adjust the default options if the parameter was provided
  def self.determine_configuration_options
    if (@parameter_handler.repository.parameters[:option])
      @option_handler.process_parameter(@parameter_handler.
                                        repository.parameters[:option])
    end
  end

  # call to print the help text
  def self.print_help
    HelpOutput.print_help_for(@parameter_handler.repository.parameters[:help])
  end

  # call to print version number and author
  def self.print_version
    puts "terminal_visualization version 0.9.2".yellow
    puts "Created by Benjamin Held (June 2015)".yellow
  end

  # call for standard error output
  # @param [String] message message string with error message
  def self.print_error(message)
    puts "#{message}".red
    puts "For help type: ruby <script> --help".green
  end

  # checks if option -i was used, determines if a valid parameter was entered
  # and returns the index on success
  # @param [VisMetaData] meta_data the meta data which should be checked for the
  #  corresponding index
  # @return [Integer] the index from the parameter, default return is 0
  def self.get_and_check_index(meta_data)
    index = 0   # default data set if -i not set or only one data set
    if (@parameter_handler.repository.parameters[:index])
      begin   # make sure that parameter of -i is an integer
        index = Integer(@parameter_handler.repository.parameters[:index]) - 1
      rescue ArgumentError
        message = " Error: argument of -i is not a number: " \
                  "#{@parameter_handler.repository.parameters[:index]}".red
        print_error(message)
      end

      check_index(meta_data, index)
    end

    return index
  end

  # method to check if provided integer index lies in range of dataseries
  # @param [VisMetaData] meta_data the meta data which should be checked for the
  #  corresponding index
  # @param [Integer] index the given index from the input
  private_class_method def self.check_index(meta_data, index)
    if (index < 0 || index >= @data_repo.repository[meta_data].series.size)
      text_index = @parameter_handler.repository.parameters[:index]
      data_size = @data_repo.repository[meta_data].series.size
      message = " Error: input #{text_index} for -i is not valid" \
                " for dataset with length #{data_size}".red
      print_error(message)
    end
  end

end
