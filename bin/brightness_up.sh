#!/bin/bash

#requires the xbacklight package.

#Terrible hack, that0s not at all how you typecast but it works :shrug:
BRIGHTNESS=$(xbacklight -get|cut -d '.' -f 1)

if [[ $BRIGHTNESS -lt 100 ]] 
then
	xbacklight -inc 10
	exit 0
else
	exit 1
fi
