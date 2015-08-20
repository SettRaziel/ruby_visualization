# @Author: Benjamin Held
# @Date:   2015-05-30 08:57:40
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-20 10:43:23

# Class to modify a String in color and typo
# \e stands for the esc code
class String

  # String => colored bright
  def bright
    "\e[1m#{self}\e[0m"
  end

  # String => colored gray
  def gray
    "\e[2m#{self}\e[0m"
  end

  # String => formatted in italic
  def italic
    "\e[3m#{self}\e[0m"
  end

  # String => formatted as underlined String
  def underline
    "\e[4m#{self}\e[0m"
  end

  # String => colored blink
  def blink
    "\e[5m#{self}\e[0m"
  end

  # String => exchanged color and background
  def exchange_grounds
    "\e[7m#{self}\e[0m"
  end

  # String => colored with background color
  def hide
    "\e[8m#{self}\e[0m"
  end

  # String => colored black
  def black
    "\e[30m#{self}\e[0m"
  end

  # String => colored red
  def red
    "\e[31m#{self}\e[0m"
  end

  # String => colored light_red
  def light_red
    "\e[91m#{self}\e[0m"
  end

  # String => colored green
  def green
    "\e[32m#{self}\e[0m"
  end

  # String => colored light_green
  def light_green
    "\e[92m#{self}\e[0m"
  end

  # String => colored yellow
  def yellow
    "\e[33m#{self}\e[0m"
  end

  # String => colored light_yellow
  def light_yellow
    "\e[93m#{self}\e[0m"
  end

  # String => colored blue
  def blue
    "\e[34m#{self}\e[0m"
  end

  # String => colored light_blue
  def light_blue
    "\e[94m#{self}\e[0m"
  end

  # String => colored magenta
  def magenta
    "\e[35m#{self}\e[0m"
  end

  # String => colored light_magenta
  def light_magenta
    "\e[95m#{self}\e[0m"
  end

  # String => colored cyan
  def cyan
    "\e[36m#{self}\e[0m"
  end

  # String => colored light_cyan
  def light_cyan
    "\e[96m#{self}\e[0m"
  end

  # String => colored light_gray
  def light_gray
    "\e[37m#{self}\e[0m"
  end

  # String => colored white
  def white
    "\e[97m#{self}\e[0m"
  end

  # String => background colored black
  def black_bg
    "\e[40m#{self}\e[0m"
  end

  # String => background colored red
  def red_bg
    "\e[41m#{self}\e[0m"
  end

  # String => background colored light_red
  def light_red_bg
    "\e[101m#{self}\e[0m"
  end

  # String => background colored green
  def green_bg
    "\e[42m#{self}\e[0m"
  end

  # String => background colored light_green
  def light_green_bg
    "\e[102m#{self}\e[0m"
  end

  # String => background colored yellow
  def yellow_bg
    "\e[43m#{self}\e[0m"
  end

  # String => background colored light_yellow
  def light_yellow_bg
    "\e[103m#{self}\e[0m"
  end

  # String => background colored blue
  def blue_bg
    "\e[44m#{self}\e[0m"
  end

  # String => background colored light_blue
  def light_blue_bg
    "\e[104m#{self}\e[0m"
  end

  # String => background colored magenta
  def magenta_bg
    "\e[45m#{self}\e[0m"
  end

  # String => background colored light_magenta
  def light_magenta_bg
    "\e[105m#{self}\e[0m"
  end

  # String => background colored cyan
  def cyan_bg
    "\e[46m#{self}\e[0m"
  end

  # String => background colored light_cyan
  def light_cyan_bg
    "\e[106m#{self}\e[0m"
  end

  # String => background colored white
  def white_bg
    "\e[107m#{self}\e[0m"
  end

  # String => background colored light_gray
  def light_gray_bg
    "\e[47m#{self}\e[0m"
  end

  # String => background colored dark_gray
  def dark_gray_bg
    "\e[100m#{self}\e[0m"
  end

end
