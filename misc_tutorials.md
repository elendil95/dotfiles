
# How to setup GTK themes in qtile:

1. install **gnome-settings-daemon** if not present.

2. install **xsettingsd** if not present.

3. grab some dank themes and install them in /usr/share/themes/ and /usr/share/icons/ (Using Arc-dark theme + Papirus icon set from the Debian repos atm)

4. run gnome-settings-deamon.

5. While it is running, run **dump\_xsettings > .xsettingsd** to generate a config file.

6. Go into the file and change the theme to whatever using the sub-directory name in /usr/share/whatevs

7. Put **xsettingsd &** in the autogen script and profit!  
