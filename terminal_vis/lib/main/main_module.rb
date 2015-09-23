# @Author: Benjamin Held
# @Date:   2015-08-20 08:40:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-23 08:49:18

# This module holds the main singleton methods that are called form the script.
# It also stores the data ans parameter repository so it can be called from
# the other classes and modules if they need data oder parameter informations.
module TerminalVis

  require_relative '../data/data_repository'
  require_relative '../output/data_output'
  require_relative '../output/help_output'
  require_relative '../output/timeline_output'
  require_relative '../parameter/parameter_handler'
  require_relative '../math/interpolation'
  require_relative '../math/dataset_statistics'
  require_relative '../math/time_line'

  # Dummy class to get access to the instance variables
  class << self
    attr_reader :data_repo, :parameter_handler
  end

  # singleton method to initialize the required repositories
  # @param [Array] arguments the input values from {ARGV}
  def self.initialize_repositories(arguments)
      @parameter_handler = ParameterHandler.new(arguments)
      @data_repo = DataRepository.new()
  end

  # creates the meta data based on the provided parameters
  def self.create_metadata
    begin
      if (@parameter_handler.repository.parameters[:meta])
        @data_repo.add_data(@parameter_handler.repository.parameters[:file])
      else
        @data_repo.add_data_with_default_meta(
                       @parameter_handler.repository.parameters[:file])
      end
    rescue Exception => e
      print_error(' Error while creating metadata: '.concat(e.message))
    end
  end

  # call to print the help text
  def self.print_help
    HelpOutput.print_help_for(@parameter_handler.repository.parameters[:help])
    exit(0)
  end

  # call to print version number and author
  def self.print_version
    puts 'terminal_visualization version 0.5.1'
    puts 'Created by Benjamin Held (June 2015)'
    exit(0)
  end

  # call for standard error output
  # @param [String] message message string with error message
  def self.print_error(message)
    STDERR.puts "#{message}"
    STDERR.puts 'For help type: ruby <script> --help'
    exit(0)
  end

  # checks if option -i was used, determines if a valid parameter was entered
  # and returns the index on success
  # @param [MetaData] meta_data the meta_data which should be checked for the
  #  corresponding index
  # @return [Integer] the index from the parameter, default return is 0
  def self.get_and_check_index(meta_data)
    index = 0   # default data set if -i not set or only one data set
    if (@parameter_handler.repository.parameters[:index])
      begin   # make sure that parameter of -i is an integer
        index = Integer(@parameter_handler.repository.parameters[:index]) - 1
      rescue ArgumentError
        message = " Error: argument of -i is not a number:" \
                  "#{@parameter_handler.repository.parameters[:index]}"
        print_error(message)
      end

      check_index(index)
    end

    return index
  end

  # method to check a given index if it is in the given range
  # @param [Integer] index the given index from the input
  def self.check_index(index)
    # check if provided integer index lies in range of dataseries
    if (index < 0 ||
      index >= @data_repo.repository[meta_data].series.size)
      text_index = @parameter_handler.repository.parameters[:index]
      data_size = @data_repo.repository[meta_data].series.size
      message = " Error: input #{text_index} for -i is not valid" \
                " for dataset with length #{data_size}"
      print_error(message)
    end
  end
  private_class_method :check_index

end

require_relative '../output/output'
require_relative '../math/interpolation'
