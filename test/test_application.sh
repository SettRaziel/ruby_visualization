# @Author: Benjamin Held
# @Date:   2018-01-27 17:34:09
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2018-02-03 10:19:47

# testing basic -h/--help
ruby ../bin/terminal_vis.rb -h
echo
echo "General help output should appear. Press key to continue..."
read

ruby ../bin/terminal_vis.rb --help
echo
echo "General help output should appear. Press key to continue..."
read

# testing -v/--version
ruby ../bin/terminal_vis.rb -v
echo
echo "Version info should appear. Press key to continue..."
read

ruby ../bin/terminal_vis.rb --version
echo
echo "Version should appear. Press key to continue..."
read

# testing basic data set without meta data
ruby ../bin/terminal_vis.rb ./test_data
echo
echo "Test data output should appear. Press key to continue..."
read

# testing basic data set without meta data; showing extreme values
ruby ../bin/terminal_vis.rb -e ./test_small
echo
echo "Test data output should appear. Press key to continue..."
read

# testing specific dataset from data with meta data
ruby ../bin/terminal_vis.rb -m -i 1 ./test_small_meta
echo
echo "Test data output should appear. Press key to continue..."
read

# testing difference from two data sets from data with meta data
ruby ../bin/terminal_vis.rb -m -d 1 2 ./test_small_meta
echo
echo "Test data output should appear. Press key to continue..."
read

# testing timeline for a given data point from data with meta data
ruby ../bin/terminal_vis.rb -m -t 1 1 ./test_small_meta
echo
echo "Test data output should appear. Press key to continue..."
read

# testing scaled output from the first data set from data with meta data
ruby ../bin/terminal_vis.rb -m -i 1 -c 2 2 -s 1 0.1 ./test_small_meta
echo
echo "Scaled test data output should appear. Press key to continue..."
read
