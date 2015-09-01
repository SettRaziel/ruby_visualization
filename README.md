# Terminal Visualizer
Ruby program to read a series of datasets from a csv-formatted file and
visualize the data as terminal output. The first line of data will be drawn
as the bottom line in the visualized output.

You can choose between the following output:
* Visualization of a dataset from a series of data
* Visualization of the value differences of two datasets
* Visualization of a timeline from a point within the data domain
* Animation of all dataset
* Interpolation of a value of a dataset within the data domain

## Usage & Help
```
usage: ruby terminal_vis.rb [parameter] <filename>
help usage : ruby terminal_vis.rb [parameter]  (-h | --help)
parameters:
-h, --help     show help text
-v, --version  prints the current version of the project
-m             process the file <filename> containing meta data
-a, --all      argument: <speed>; prints all possible datasets of a data series
               with a pause between the output of every dataset defined by
               speed: 0 mean manual, a value > 0 an animation speed in seconds,
               excludes -i, -d and -t
-c, --coord    arguments: <x> <y>; interpolates the data for the given
               coordinate (x,y) at default dataset index 0, excludes -e and -t
-d, --delta    arguments: <first_index> <second_index>; subtracts the first
               dataset from the second dataset and visualizes the difference,
               excludes -a, -i and -t
-e, --extreme  marks the extreme values in a dataset with ++ for a maximum
               and -- for a minimum, also prints the coordinates of the
               extreme values below the legend, excludes -c
-i             argument: <index>; shows the dataset at index, if index lies
               within [1,2, ..., number of datasets], excludes -a, -d and -t
-t, --time     arguments: <x> <y> ; creates a timeline for the given coordinate
               (x,y), coordinates not lying on the data point will be
               interpolated, excludes -a, -c and -i
```

### Invalid parameter combinations
```
    -a + -d, -a + -i, -a + -t
    -c + -e, -c + -t
    -d + -i, -d + -t
```

### Examples
Reading a data series from <filename> with meta data and visualizing the first
dataset:
```
ruby terminal_vis.rb -m <filename>
```

Reading a data series from <filename> without meta data and visualizing the
dataset at <index>:
```
ruby terminal_vis.rb -i <index> <filename>
```

Reading a data series from <filename> with meta data and creating a timeline
for the coordinate (<x>,<y>):
```
ruby terminal_vis.rb -m -t <x> <y> <filename>
```

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
Written with Ruby 2.2.2

## Tested
* Linux: running with Ruby 2.2.2
* Windows: not tested
* MAC: not tested

## Requirements
* Ruby with a version > 2.2
* matrix (all)
* csv (all)
* Win32/Console/ANSI (Windows)

## License
see LICENSE

created by: Benjamin Held
