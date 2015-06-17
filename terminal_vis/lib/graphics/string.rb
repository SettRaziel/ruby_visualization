# @Author: Benjamin Held
# @Date:   2015-05-30 08:57:40
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-06-17 17:36:03

# Class to modify a String in color and typo
class String

# String => colored bright
def bright
    "\033[1m#{self}\033[0m"
end

# String => colored gray
def gray
    "\033[2m#{self}\033[0m"
end

# String => formatted in italic
def italic
    "\033[3m#{self}\033[0m"
end

# String => formatted as underlined String
def underline
    "\033[4m#{self}\033[0m"
end

# String => colored blink
def blink
    "\033[5m#{self}\033[0m"
end

def exchange_grounds
    "\033[7m#{self}\033[0m"
end

# String => colored with background color
def hide
    "\033[8m#{self}\033[0m"
end

# String => colored black
def black
    "\033[30m#{self}\033[0m"
end

# String => colored red
def red
    "\033[31m#{self}\033[0m"
end

# String => colored green
def green
    "\033[32m#{self}\033[0m"
end

# String => colored yellow
def yellow
    "\033[33m#{self}\033[0m"
end

# String => colored blue
def blue
    "\033[34m#{self}\033[0m"
end

# String => colored magenta
def magenta
    "\033[35m#{self}\033[0m"
end

# String => colored cyan
def cyan
    "\033[36m#{self}\033[0m"
end

# String => colored white
def white
    "\033[37m#{self}\033[0m"
end

# String => background colored black
def black_bg
    "\033[40m#{self}\033[0m"
end

# String => background colored red
def red_bg
    "\033[41m#{self}\033[0m"
end

# String => background colored green
def green_bg
    "\033[42m#{self}\033[0m"
end

# String => background colored yellow
def yellow_bg
    "\033[43m#{self}\033[0m"
end

# String => background colored blue
def blue_bg
    "\033[44m#{self}\033[0m"
end

# String => background colored magenta
def magenta_bg
    "\033[45m#{self}\033[0m"
end

# String => background colored cyan
def cyan_bg
    "\033[46m#{self}\033[0m"
end

# String => background colored white
def white_bg
    "\033[47m#{self}\033[0m"
end

end
