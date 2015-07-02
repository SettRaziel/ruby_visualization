# Terminal Visualizer
Ruby program to read a data set from a csv-formatted file and visualize
the data as terminal output. The first line of data will be drawn as the
bottom line in the visualized output.

## Usage
```
usage: ruby terminal_vis.rb [parameter] <filename>
parameters:
-h, --help     show help text
-v, --version  prints the current version of the project
-m             process the file <filename> containing meta data
-i <index>     shows the dataset at index, if index lies within
               [1,2, ..., number of datasets]
```

##Meta data format (in single line):
#### Two dimensional data set:
```
<data_name>,
<axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,<step_range_x>,
<axis_description_y>,<lower_boundary_y>,<upper_boundary_y>,<step_range_y>
```

#### Three dimensional data set:
```
<data_name>,
<axis_description_x>,<lower_boundary_x>,<upper_boundary_x>,<step_range_x>,
<axis_description_y>,<lower_boundary_y>,<upper_boundary_y>,<step_range_y>,
<axis_description_z>,<lower_boundary_z>,<upper_boundary_z>,<step_range_z>
```

## Used version
Written in Ruby 2.2.2

## Tested
* Linux: running with Ruby 2.2.2
* Windows: not tested

## Requirements
* csv (all)
* Win32/Console/ANSI (Windows)

## License
see LICENSE

created by: Benjamin Held
