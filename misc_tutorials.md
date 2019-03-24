
# How to setup GTK themes in qtile (Linux Mint):

1. install **gnome-settings-daemon** if not present.

2. install **xsettingsd** if not present.

3. grab some dank themes and install them in /usr/share/themes/ and /usr/share/icons/ (Using Arc-dark theme + Papirus icon set from the Debian repos atm)

4. run gnome-settings-deamon.

5. While it is running, run **dump\_xsettings > .xsettingsd** to generate a config file.

6. Go into the file and change the theme to whatever using the sub-directory name in /usr/share/whatevs

7. Put **xsettingsd &** in the autogen script and profit! 

#How to get global screen locking to work: (not sure it does anything tho)

move ~/bin/lock_screen into the path like in /usr/bin/
run

'''
xfconf-query -c xfce4-session -p /general/LockCommand -s "$NAME_OF_BINARY"
'''
Profit!

Note: the light locker command in autostart.sh should take care of locking when in sleep already, but not when the pc goes idle and blanks out. this should take care of that 
