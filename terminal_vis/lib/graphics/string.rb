# @Author: Benjamin Held
# @Date:   2015-05-30 08:57:40
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-05-30 12:17:22

class String

def bright
    "\033[1m#{self}\033[0m"
end

def gray
    "\033[2m#{self}\033[0m"
end

def italic
    "\033[3m#{self}\033[0m"
end

def underline
    "\033[4m#{self}\033[0m"
end

def blink
    "\033[5m#{self}\033[0m"
end

def exchange_grounds
    "\033[7m#{self}\033[0m"
end

def hide
    "\033[8m#{self}\033[0m"
end

def black
    "\033[30m#{self}\033[0m"
end

def red
    "\033[31m#{self}\033[0m"
end

def green
    "\033[32m#{self}\033[0m"
end

def yellow
    "\033[33m#{self}\033[0m"
end

def blue
    "\033[34m#{self}\033[0m"
end

def magenta
    "\033[35m#{self}\033[0m"
end

def cyan
    "\033[36m#{self}\033[0m"
end

def white
    "\033[37m#{self}\033[0m"
end

def black_bg
    "\033[40m#{self}\033[0m"
end

def red_bg
    "\033[41m#{self}\033[0m"
end

def green_bg
    "\033[42m#{self}\033[0m"
end

def yellow_bg
    "\033[43m#{self}\033[0m"
end

def blue_bg
    "\033[44m#{self}\033[0m"
end

def magenta_bg
    "\033[45m#{self}\033[0m"
end

def cyan_bg
    "\033[46m#{self}\033[0m"
end

def white_bg
    "\033[47m#{self}\033[0m"
end

end
