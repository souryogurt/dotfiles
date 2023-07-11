#!/bin/bash

battery_info=$(upower -e | grep -m 1 -E 'battery|DisplayDevice')

state=$(upower -i "$battery_info" | awk -F': ' '/state/ {gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2}')
percentage=$(upower -i "$battery_info" | awk -F': ' '/percentage/ {gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2}')

date=$(LC_ALL=ru_RU.UTF-8 date +"%x")
time=$(LC_ALL=ru_RU.UTF-8 date +"%X")

printf "<b>%-14s</b> %s\n" "Дата:" "$date"
printf "<b>%-15s</b> %s\n" "Время:" "$time"
printf "<b>%-15s</b> %s\n" "Заряд:" "$percentage"

if [[ "$state" == "charging" ]]; then
    time_to_full=$(upower -i "$battery_info" | awk -F': ' '/time to full/ {gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2}')
    printf "<b>%-15s</b> %s\n" "До заряда:" "$time_to_full"
elif [[ "$state" == "discharging" ]]; then
    time_to_empty=$(upower -i "$battery_info" | awk -F': ' '/time to empty/ {gsub(/^[ \t]+|[ \t]+$/,"",$2); print $2}')
    printf "<b>%-18s</b> %s\n" "Осталось:" "$time_to_empty"
else
    printf "<b>%-16s</b> %s\n" "Статус:" "$state"
fi
