#!/bin/bash

# 步进值
STEP=5

case $1 in
up)
  brightnessctl set ${STEP}%+
  ;;
down)
  brightnessctl set ${STEP}%-
  ;;
esac

# 获取当前亮度百分比
# brightnessctl 返回类似 "450 (15%)" 的字符串，我们要提取出数字
LEVEL=$(brightnessctl g | awk -v max=$(brightnessctl m) '{print int($1/max*100)}')

# 发送通知
# -h int:value:"$LEVEL" 会在 dunst 中渲染出进度条
dunstify -a "Backlight" -u low -i display-brightness -r 998 -h int:value:"$LEVEL" "Brightness: ${LEVEL}%"
