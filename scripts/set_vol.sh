#!/bin/bash

# 使用 wpctl 获取当前音量状态
get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

is_mute() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"
}

# 发送通知的函数
send_notification() {
  local volume=$(get_volume)

  if is_mute; then
    icon="audio-volume-muted"
    dunstify -a "volume" -u low -i -h VOL: "MUTED"
  else
    #dunstify -a "volume" -u low -i -h VOL:"$volume" -h string:x-dunst-stack-tag:volume "音量: $volume%"
    dunstify -a "volume" -u low -i -h VOL:"$volume"% -h string:x-dunst-stack-tag:volume
  fi
}

case $1 in
up)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
  send_notification
  ;;
down)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  send_notification
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  send_notification
  ;;
mic)
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
    dunstify -a "mic" -u low -i audio-input-microphone-muted -h string:x-dunst-stack-tag:mic "麦克风: 已静音"
  else
    dunstify -a "mic" -u low -i audio-input-microphone -h string:x-dunst-stack-tag:mic "麦克风: 已开启"
  fi
  ;;
esac
