require_relative '../lib/data/data_input'
require_relative '../lib/main/main_module'

#-------------------------------------------------------------------------------
# Terminal Visualization Script
# Version 0.9.2
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
  TerminalVis.determine_configuration_options

  if (parameter_handler.repository.parameters[:help])
  TerminalVis.print_help() 
  elsif (parameter_handler.repository.parameters[:version])
    TerminalVis.print_version()
  else
    meta_data = TerminalVis.create_metadata()

    if (parameter_handler.repository.parameters[:time])
      TerminalVis::Output.create_timeline(meta_data)
    elsif (parameter_handler.repository.parameters[:section])
      TerminalVis::Output.create_region_interpolation_output(meta_data)
    elsif (parameter_handler.repository.parameters[:coord])
      TerminalVis::Output.create_interpolation_output(meta_data)
    elsif (parameter_handler.repository.parameters[:range])
      TerminalVis::Output.create_range_output(meta_data)
    elsif (parameter_handler.repository.parameters[:delta])
      TerminalVis::Output.create_delta_output(meta_data)
    else
      TerminalVis::Output.create_output(meta_data)
    end
  end
rescue StandardError, NotImplementedError => e
    TerminalVis.print_error(e.message)
end
