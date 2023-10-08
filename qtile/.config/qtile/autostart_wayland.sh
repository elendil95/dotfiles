#!/bin/sh

swaybg -i "$(cat ~/.cache/wal/wal)" &
way-displays -Lerror &

# xfce4-power-manager &
nm-applet &
syncthing-gtk -m &
gammastep-indicator &
blueman-applet &
/usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
# pamac-tray-appindicator &
export MOZ_ENABLE_WAYLAND=1
