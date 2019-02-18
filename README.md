# DOTFILE LOCATIONS

## HOME

- .bashrc (from laptop)
- .profile (for Bash)
- .zshrc (Where plugins are set)
- .Xresources
- .vimrc

## Oh my zshell folder (~/.oh-my-zshell/)

- .oh-my-zshell.sh
- custom/example.zsh (source custom plugins)
- custom/aliases.zsh (all of the aliases)
- custom/plugins/ (the whole folder)

## .conkycolors

- conkyrc (source with 'conky -c /home/elendil/.conkycolors/conkyrc')

## .config/

**QTile** (see [here](QTile_keys.md) for a list of QTile Keybinds)

- config.py
- autostart.sh (for startup programs) 

**texstudio**

- eu.txsprofile

**Ranger**

- rc.conf
- rifle.conf
- scope.sh

## Etc

acpi/ *extra acpi settings for suspening the laptop once the lid is closed; Also needs XScreensaver to lock the screen*

## Bin 

small miscellaneous scripts to be used with QTile

## Resources

Assets and helper scripts to be used with QTile

# How to setup GTK themes in qtile:

1. install **gnome-settings-daemon** if not present.

2. install **xsettingsd** if not present.

3. grab some dank themes and install them in /usr/share/themes/ and /usr/share/icons/ (Using Arc-dark theme + Papirus icon set from the Debian repos atm)

4. run gnome-settings-deamon.

5. While it is running, run **dump\_xsettings > .xsettingsd** to generate a config file.

6. Go into the file and change the theme to whatever using the sub-directory name in /usr/share/whatevs

7 Put **xsettingsd &** in the autogen script and profit!  

## Get Window names to set individual floating layout
xlsclients -l

## Programs necessary for ranger

-w3m
-w3m-img
-trash-cli
-atools

use rxvt-unicode-256-colors package for Powerline support
