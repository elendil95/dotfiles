#!/bin/bash
set -e
cd ~
sudo pacman -Syyu --noconfirm
sudo pacman -S --noconfirm --needed vim git

#Optimize Pacman for multiple cores
echo "#########################"
echo "### OPTIMIZING PACMAN ###"
echo "########################"
numberofcores=$(grep -c ^processor /proc/cpuinfo)


case $numberofcores in

    16)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j17"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 16 -z -)/g' /etc/makepkg.conf
        ;;
    8)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j9"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf
        ;;
    6)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j7"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 6 -z -)/g' /etc/makepkg.conf
        ;;
    4)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf
        ;;
    2)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j3"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 2 -z -)/g' /etc/makepkg.conf
        ;;
    *)
        echo "We do not know how many cores you have."
        echo "Do it manually."
        ;;

esac

echo "################################################################"
echo "###  All cores will be used during building and compression ####"
echo "################################################################"

#Install LightDM and XFCE4

echo "#########################"
echo "### INSTALLING XFCE4 ###"
echo "########################"

sudo pacman -S --needed --noconfirm lightdm
sudo pacman -S --needed --noconfirm lightdm-gtk-greeter lightdm-gtk-greeter-settings
sudo pacman -S --needed --noconfirm xfce4 xfce4-goodies
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target

#Install Sound
echo "#########################"
echo "### INSTALLING SOUND ###"
echo "########################"

sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa pavucontrol alsa-utils alsa-plugins alsa-lib alsa-firmware gstreamer gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly volumeicon playerctl

#Install printing stuff

echo "###########################"
echo "### INSTALLING PRINTERS ###"
echo "##########################"

sudo pacman -S --needed --noconfirm cups cups-pdf ghostscript gsfonts gutenprint gtk3-print-backends libcups hplip system-config-printer

sudo systemctl enable org.cups.cupsd.service

#Install TLP

echo "###################################"
echo "### INSTALLING POWER MANAGEMENT ###"
echo "###################################"

sudo pacman -S --needed --noconfirm tlp
sudo systemctl enable tlp.service
sudo systemctl start tlp-sleep.service

#Install fonts (we'll deal later with urxvt specific fonts)

echo "##############################"
echo "### FINISHING XFCE INSTALL ###"
echo "#############################"

sudo pacman -S --needed --noconfirm ttf-ubuntu-font-family ttf-droid ttf-dejavu ttf-hack

echo "Would you like to install extra software for a more out-of-the-box experience? \[y/n\}"
read ANSWER
if [ANSWER == "y"]
then 
    sudo pacman -S --noconfirm --needed gnome-screenshot gnome-calculator xfburn redshift redshift-gtk gimp gimp-font-viewer pinta ristretto vlc quodlibet firefox thunderbird filezilla hexchat qbittorrent wireshark mpv vlc simplescreenrecorder screenkey quodlibet easytag libreoffice-fresh pyroom gvim retext evince zathura mupdf arc-gtk3-theme baobab curl dconf-editor gnome-disk-utility gnome-system-monitor gnome-terminal gparted grsync gvfs gvfs-mtp htop kvantum-qt5 kvantum-theme-arc lsb-release mlocate net-tools notify-osd noto-fonts numlockx neofetch scrot simple-scan thunar thunar-archive-plugin thunar-volman pcmanfm tumbler wget unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller keepass
fi

#Install AUR Helper (yay)
cd /tmp/
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg --needed -Acs
makepkg -i
cd ~


echo "Would you like to install some proprietary software? \[y/n\]"
read ANSWER2
if [ANSWER2=="Y"]
then
    yay --noconfirm --needed -S discord visual-studio-code-bin gitkraken
fi 

echo "Would you like to install Latex and related software? \[y/n\]"
read ANSWER3
if [ANSWER3=="Y"]
then
    sudo pacman --noconfirm --needed texlive-full
    yay --noconfirm --needed -S texstudio-dark-git
fi

## Main Desktop installed

#Creating personal directories
sudo pacman -S --noconfirm xdg-user-dirs xdg-user-dirs-gtk
xdg-user-dirs-update
xdg-user-dirs-update --force
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

#Set up URXVT (The powerline stuff is still quite experimental)
echo "#########################"
echo "### SETTING UP URXVT ###"
echo "########################"

sudo pacman -S --needed --noconfirm rxvt-unicode urxvt-perls
sudo pacman -S --needed python-pip python2-pip python-setuptools python2-setuptools
sudo pip install powerline-status
cd /tmp
git clone https://github.com/powerline/fonts.git
cd powerline-fonts
exec ./install.sh
cd ~
yay -S --needed --noconfirm ttf-nerd-fonts-hack-complete-git

#Clone dotfiles repo
git clone https://github.com/elendil95/dotfiles.git
cp ~/dotfiles/.Xresources ~/.Xresources

#Set up zsh
echo "######################"
echo "### SETTING UP ZSH ###"
echo "######################"

sudo pacman -S --needed  --noconfirm zsh zsh-doc zsh-autosuggestions zsh-completions zsh-lovers tig
cp ~/dotfiles/.zshrc ~/.zshrc
sudo usermod -s /bin/zsh $(whoami)
## Setup oh-my-zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools    /install.sh)"
cd .oh-my-zsh/
cp -vf ~/dotfiles/.oh_my_zsh/oh-my-zsh.sh .
cp -vrf ~/dotfiles/.oh_my_zsh/custom/*.zsh ./custom/
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#Setup vim with powerline
echo "######################"
echo "### SETTING UP VIM ###"
echo "######################"

cd ~
cp -vf ~/dotfiles/.vimrc .
sed 's/" //g' .vimrc

#Set up Qtile (finally)

echo "########################"
echo "### SETTING UP QTILE ###"
echo "########################"

sudo pacman -S --needed --noconfirm qtile
#Maybe i need to add qtile to the sessions?
sudo pacman --S --needed --noconfirm network-manager-applet redshift redshift-gtk feh nitrogen syncthing-gtk maim notify-osd dmenu firefox cmus w3m trash-cli atool highlight rangercalcurse light-locker
yay -S --needed light-git pamac-aur pamac-tray-appindicator
sudo pip install pywal

cp -fv ~/dotfiles/.config/qtile/config.py ~/.config/qtile/
cp -fv ~/dotfiles/.config/qtile/autostart.sh ~/.config/qtile/
[ -d $HOME"/bin"] || mkdir -p $HOME"/bin"
cp -fv ~/dotfiles/bin/* ~/bin/

#Copy files that remain
cp -vf ~/dotfiles/.dircolors ~/
cp -vf ~/dotfiles/.bashrc ~
cp -vf ~/dotfiles/.profile ~/
cp -vf ~/dotfiles/.bash_aliases ~/

#Setup Ranger

echo "#########################"
echo "### SETTING UP RANGER ###"
echo "#########################"

ranger --copy-config=all
cp -vf ~/dotfiles/.config/ranger/rc.conf ~/.config/ranger/
cp -vf ~/dotfiles/.config/ranger/rifle.conf ~/.config/ranger/
cp -vf ~/dotfiles/.config/ranger/scope.conf ~/.config/ranger/
