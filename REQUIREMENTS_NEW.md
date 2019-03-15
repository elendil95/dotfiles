# Setup notes for Arch Linux

**This is a very messy outline of the steps to get Qtile working using my config alongside all the other needed programs.You will likely need to add/fix some stuff before it will run smoothly**

Before anything you will likely need git and vim.

I have chosen XFCE as a fallback desktop; you can choose to set it up quickly using the Arcolinux XFCE scripts.
I have included the relevant ones in the resources folder, but its much better to grab the updated ones from the official repo [here](https://github.com/arcolinuxd/arco-xfce).

In case you wanna use the my local copy of the arcolinux scripts, read [here](resources/arcolinux/README.md)

Take a look at the shell code before running them in case there are packages you do not want; I reccomend running scripts 000 through 200 and script 700. skip 140 and 150 if you don't want samba. then install an aur helper like yay and run script 300.

You can populate your home folder with directories by installing xdg-user-dirs and running the "install personal folders" script in the resources/arcolinux/suggested directory.

Before we pull our config files, we need to grab keepass (*sic.* found in arch repos) and setup our git user: you can do that by editing the git_setup_public script found in resources/scripts with the relevant information, and running it.
After you enter your credentials once on a push/pull they wil be saved.

Next: to **set up urxvt, you will need these packages from the official repos**

- ttf-dejavu
- rxvt-unicode
- urxvt-perls
- ttf-hack
- zsh

In order to get Icons in Ranger we need to grab The Nerd font version on Hack from the AUR

- ttf-nerd-fonts-hack-complete-git **or**
- nerd-fonts-complete (for the whole package, but its like 7GBs of fonts)

copying .Xresources to the home folder should work at this point 

then clone the oh-my-zsh repo

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

change shell (as superuser) usermod -s /bin/zsh $USERNAME (i don't remeber the command exactly but that should work). reboot just in case

## Required packages from autostart.sh

- network-manager-applet (pac)
- redshift (pac)
- feh
- pywal (pip)
- syncthing-gtk (pac)

## Required Packages for screenshot/background

- maim (pac)
- notify-osd (pac)

# Programs required by qtile config

- dmenu (pac)
- chromium (pac)
- cmus (pac)
- ranger (pac)
    - w3m (pac)
    - trash-cli (pac)
    - atool (pac)
    - highlight (pac)
    - also run "ranger --copy-config=all" to generate the config files
- light-git (aur) for backlight adjustment
- light-locker (pac) and dm-tool(pac, included with lightdm) for locking the screen
- calcurse
- pamac-aur (aur)
- pamac-tray-appindicator (aur) *for update notifications*

# Misc programs
- tig (pac) to get 'gt' alias to work
