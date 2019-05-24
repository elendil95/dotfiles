#!/bin/sh

compton -b --config ~/.config/compton/compton.conf &
nitrogen --restore &
xsettingsd &
# xfce4-power-manager &
# volumeicon &
nm-applet &
syncthing-gtk -m &
redshift-gtk &
setxkbmap it
light-locker --lock-on-suspend &
pamac-tray-appindicator &
exec expressvpn connect &
exit 0
