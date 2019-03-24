#!/bin/sh

# feh --bg-scale /home/elendil/Pictures/ParrotOS\ Wallpapers/outerspaceEarth.jpg &
nitrogen --restore &
xsettingsd &
xfce4-power-manager &
volumeicon &
nm-applet &
syncthing-gtk -m &
redshift-gtk &
setxkbmap it
light-locker --lock-on-suspend &
pamac-tray-appindicator &
exec expressvpn connect &
exit 0
