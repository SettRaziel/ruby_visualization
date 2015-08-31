# @Author: Benjamin Held
# @Date:   2015-05-31 14:25:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-28 11:55:26


require_relative '../lib/data/data_repository'
require_relative '../lib/output/data_output'
require_relative '../lib/output/help_output'
require_relative '../lib/parameter/parameter_handler'
require_relative '../lib/math/interpolation'
require_relative '../lib/math/dataset_statistics'
require_relative '../lib/main/main_module'

#-------------------------------------------------------------------------------
# Terminal Visualization Script
# Version 0.4.0
# created by Benjamin Held, June 2015
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows.'
end

if (ARGV.length < 1)
  message = 'Invalid number of arguments: usage ruby <script> ' \
  '[parameters] <filename>'
  TerminalVis.print_error(message)
end

begin
  TerminalVis::initialize_repositories(ARGV)
  parameter_handler = TerminalVis.parameter_handler

  TerminalVis.print_help() if (parameter_handler.repository.parameters[:help])
  if (parameter_handler.repository.parameters[:version])
    TerminalVis.print_version()
  end

  meta_data = TerminalVis.create_metadata()

  if (parameter_handler.repository.parameters[:time])
    TerminalVis::Output.create_timeline(meta_data)
  elsif (parameter_handler.repository.parameters[:delta])
    TerminalVis::Output.create_delta_output(meta_data)
  elsif (parameter_handler.repository.parameters[:coord])
    TerminalVis::Interpolation.interpolate_for_coordinate(meta_data)
  else
    TerminalVis::Output.create_output(meta_data)
  end
rescue StandardError, NotImplementedError => e
    TerminalVis.print_error(e.message)
end
