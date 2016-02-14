# Terminal Visualizer
[![Code Climate](https://codeclimate.com/github/SettRaziel/ruby_visualization/badges/gpa.svg)](https://codeclimate.com/github/SettRaziel/ruby_visualization)

Ruby program to read a series of datasets from a csv-formatted file and
visualize the data as terminal output. The first line of data will be drawn
as the bottom line in the visualized output.

You can choose between the following output:

* Visualization of a dataset from a series of data
* Visualization of the value differences of two datasets
* Visualization of a timeline from a point within the data domain
* Animation of all datasets
* Interpolation of a value of a dataset within the data domain

## Usage & Help
```
usage: ruby terminal_vis.rb [parameter] <filename>
help usage : ruby terminal_vis.rb [parameter]  (-h | --help)
parameters:
-h, --help     show help text
-v, --version  prints the current version of the project
-m             process the file <filename> containing meta data
-a, --all      argument: <speed>; prints all specified datasets of a data series
               with a pause between the output of every dataset defined by
               speed: 0 mean manual, a value > 0 an animation speed in seconds,
               excludes -i, -d and -t
-c, --coord    arguments: <x> <y>; interpolates the data for the given
               coordinate (x,y) at default dataset index 0, excludes -e and -t
-d, --delta    arguments: <first_index> <second_index>; subtracts the first
               dataset from the second dataset and visualizes the difference,
               indices as [1,2, ..., # datasets], excludes -a, -i and -t
-e, --extreme  marks the extreme values in a dataset with ++ for a maximum
               and -- for a minimum, also prints the coordinates of the
               extreme values below the legend, excludes -c
-i             argument: <index>; shows the dataset at index, if index lies
               within [1,2, ..., number of datasets], excludes -a, -d and -t
-o, --options  argument: <option>; enables options, the source depends on the
               argument: file=<filename> loads options from file, menu enables
               the possibility to input the desired values
-r, --range    arguments: <start> <end>; prints all datasets within the range
               of the provided arguments, indices as [1,2, ..., # datasets],
               excludes -i, -t
-s, --section  arguments: <interval> <delta>; interpolates data for a given
               region specified by a coordinate, an interval and stepwidth;
               result: interpolated values in (x+-interval, y+-interval) with
               stepwidth delta, excludes -e, -t; requires -c
-t, --time     arguments: <x> <y> ; creates a timeline for the given coordinate
               (x,y), coordinates not lying on the data point will be
               interpolated, excludes -a, -c and -i
```

## Configuration parameter
Configuration paramters can be specified by the parameter -o. From their they
can inserted manually or from a file. The current parameters are:
* Timeline y-Dimension: specifies how much interval steps in y-dimension should
be used; value interval [5, 100]
* Extended color legend information: specifies if the interval values should
be displayed

### Invalid parameter combinations
```
    -a + -d, -a + -i, -a + -t
    -r + -t, -r + -i
    -c + -e, -c + -t
    -d + -i, -d + -t
```

### Examples
Reading a data series from `<filename>` with meta data and visualizing the first
dataset:
```
ruby terminal_vis.rb -m <filename>
```

Reading a data series from `<filename>` without meta data and visualizing the
dataset at `<index>`:
```
ruby terminal_vis.rb -i <index> <filename>
```

Reading a data series from `<filename>` with meta data and creating a timeline
for the coordinate `(<x>,<y>)`:
```
ruby terminal_vis.rb -m -t <x> <y> <filename>
```

Reading a data series from `<filename>` with meta data and animating a specific
interval from the data series:
```
ruby terminal_vis -m -r <start> <end> -a <speed> <filename>
```

Running the script to visualize a dataset from `<filename>` and entering
configuration option through the menu:
```
ruby terminal_vis -m -i <index> -o menu <filename>
```

Running the script to visualize a specific region of a dataset from
`<filename>`:
```
ruby terminal_vis -m -i <index> -c <x> <y> -s <interval> <delta> <filename>
```

### Documentation
Documentation is written in yard and can be created by running the shell-script
`create_yard.sh`. Yard needs to be installed on the system in order to do that.
Hopefully i find a place to publish the documentation online soon.

## Meta data format (in single line):
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
Written with Ruby 2.2.2 - 2.2.4

## Tested
* Linux: running on Archlinux with Ruby > 2.2.2
* Windows: not tested
* MAC: not tested

## Requirements
* Ruby with a version > 2.2
* matrix (all)
* csv (all)
* Win32/Console/ANSI (Windows)
* Yard (for Documentation only)

## License
see LICENSE

## Roadmap
* adding a mechanism to allow some configuration parameters to be set and
  stored within a configuartion file (done with update v0.7.1)
* adding an option to interpolate for a region of the considered x- and
  y-dimenstion
* adding a mechanism to scale the output automatically to the dimension of
  the used terminal
* adding more features from suggestions


created by: Benjamin Held
