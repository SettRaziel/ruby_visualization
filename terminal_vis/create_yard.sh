#!/bin/bash
# @Author: Benjamin Held
# @Date:   2015-08-30 09:48:37
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-07 10:42:40

exec yard doc --private
exec yard doc --private --files ../README.md
