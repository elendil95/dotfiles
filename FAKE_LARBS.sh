#!/bin/bash

#Highly experimental
echo -n "Script Starting"
pacman -S vim git

echo "STEP 1: Pulling XFCE4 Desktop and core software"

mkdir xfce-desktop && cd xfce-desktop
git clone --recursive https://github.com/arcolinuxd/arco-xfce.git
cd arco-xfce

echo "Adding Arco Linux repos to pacman..."
cd ArchWay
bash ./10-add-keyservers-for-key-importing-v4.sh && ./20-trust-key-v4.sh && 30-add-arcolinux-repo-to-pacman-conf-v5.sh
cd ..
echo "DONE"

echo "Installing Desktop enviroment and Login Manager..."
bash ./000-use-all-cores-makepkg-conf-v3.sh && ./100-display-manager-and-desktop-v1.sh

echo "Installing Core components"
./110-install-sound-v3.sh && ./120-bluetooth-v2.sh && ./130-install-printers-v3.sh &&\
    ./160-install-tlp-for-laptops-v1.sh && 700-installing-fonts-v2.sh

echo "DONE"

echo "Would you like to install additional software now fo a more out-of-the-box experience? \[Y/N\]"
read ANSWER
if [ANSWER == 'Y']
then 
    ./200-software-arch-linux-repo-v2.sh
else

fi

echo "DESKTOP INSTALLED"

echo "Populating user dirs..."
sudo pacman -S --noconfirm xdg-user-dirs xdg-user-dirs-gtk
xdg-user-dirs-update
xdg-user-dirs-update --force
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"
cd ~
echo "Done"


echo "STEP 2: Pull my own configs"

git clone --recurrsive https://github.com/elendil95/dotfiles.git
cd dotfiles

echo "setting up URXVT and ZSH..."
pacman -S --noconfirm ttf-dejavu rxvt-unicode urxvt-perls ttf-hack zsh
cp .Xresources ~/.Xresources
echo "Done"
cd ~

echo "Set up oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
sudo usermod -s /bin/zsh/ elendil
echo "Done. copy config files manually to the new oh-my-zsh install."


