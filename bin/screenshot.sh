#!/bin/bash
#
# script to take screenshot in selected area
#
###

sleep 0.2

filename=$(date +"%Y%m%d_%H%M")".png"
screenshots="/home/elendil/Pictures/screenshots"
dest="$screenshots/$filename"

# create destination directory if it does not exist
if [ ! -z "$screenshots" ]; then
    mkdir $screenshots
fi

# create screenshot
notify-send -u critical "taking screenshot..." -t 1000
scrot $filename

# move to shared folder
if [ -f "$filename" ]; then
    mv "$filename" "$dest"
fi

#echo $dest | xclip

notify-send -u critical "Screenshot $filename saved to $dest" -t 5000