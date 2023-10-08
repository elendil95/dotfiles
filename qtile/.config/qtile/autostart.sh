#!/bin/sh

picom -b --config ~/.config/picom/picom.conf
wal R
xsettingsd &
setxkbmap it
light-locker --lock-on-suspend &
# xfce4-power-manager &
#pa-applet
#volumeicon
nm-applet &
syncthing-gtk -m &
#redshift-gtk
gammastep-indicator &
blueman-applet &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &

if [ "${MOZ_ENABLE_WAYLAND}" = 1 ]; then 
    export MOZ_ENABLE_WAYLAND=0
fi
# pamac-tray-appindicator &
exec expressvpn connect