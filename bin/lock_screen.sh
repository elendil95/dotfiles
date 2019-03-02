#!/bin/bash

# Uses light-locker and dm-toom (part of lightdm)

light-locker-command -l && dm-tool switch-to-greeter
exit 0
