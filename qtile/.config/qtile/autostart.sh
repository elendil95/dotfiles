#!/bin/sh

picom -b --config ~/.config/picom/picom.conf &
wal -R
xsettingsd &
# xfce4-power-manager &
# volumeicon &
pa-applet &
nm-applet &
syncthing-gtk -m &
redshift-gtk &
blueman-applet &
setxkbmap it
light-locker --lock-on-suspend &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
# pamac-tray-appindicator &
exec expressvpn connect &
exit 0
