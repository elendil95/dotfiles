#!/bin/bash

#If the event was triggered by an open lid, do nothing
echo "$1" | grep "button/lid" && grep -q open /proc/acpi/button/lid/LID/state && exit 0

xscreensaver-command -lock

pm-suspend

exit 0
