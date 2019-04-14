#!/bin/bash
set -e
cd ~
sudo apt update && sudo apt upgrade
sudo apt install vim git curl wget

#LightDM and XFCE4
sudo apt install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
sudo apt install xfce4 xfce4-goodies
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target

#Install base fonts
sudo apt install ttf-ubuntu-font-family ttf-dejavu fonts-droid-fallback fonts-hack-ttf

#Install base software #kvantum-qt5 kvantum-theme-arc <--- missing packages
sudo apt install gnome-screenshot gnome-calculator xfburn redshift redshift-gtk gimp pinta ristretto vlc timeshift quodlibet firefox thunderbird filezilla hexchat qbittorrent wireshark mpv vlc simplescreenrecorder screenkey quodlibet easytag libreoffice pyroom vim-gtk retext evince zathura mupdf arc-theme numix-gtk-theme baobab curl dconf-editor gnome-disk-utility gnome-system-monitor gnome-terminal gparted grsync gvfs htop lsb-release mlocate net-tools notify-osd fonts-noto numlockx neofetch scrot simple-scan thunar thunar-archive-plugin thunar-volman pcmanfm tumbler wget unace unrar zip unzip sharutils uudeview arj cabextract file-roller keepass2 ntfs-3g 

#install proprietary software
sudo apt install discord visual-studio-code gitkraken

#Install latex
sudo apt install texlive-full texstudio
                                                                                        -                                                                                                                          
#Set up URXVT
sudo apt install rxvt-unicode-256color
sudo apt install python-pip python3-pip python-setuptools python3-setuptools
sudo pip3 install powerline-status
cd /tmp
git clone https://github.com/powerline/fonts.git
cd fonts
bash ./install.sh &
wait
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh Hack 
cd ~
#TODO: stow .Xresources

#Set up ZSH
sudo apt install zsh zsh-dev zsh-doc tig
sudo usermod -s /bin/zsh $(whoami)
## Install oh my zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &
wait
[ -d $HOME"/.oh-my-zsh" ] || echo "### OH MY ZSH DIR NOT FOUND!" ; exit 1
#TODO: stow oh-my-zsh and aliases
#TODO: stow zshrc
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#Set up Vim
#TODO: stow vimrc
sed -i 's/" //g' ~/.vimrc


#Set up QTile
#QTILE IS NOT AVAILBALE ON DEBIAN STABLE OR TESTING AND NEEDS TO BE INSTALLED FROM SOURCE!
sudo apt install network-manager-gnome redshift redshift-gtk feh nitrogen syncthing-gtk maim notify-osd suckless-tools firefox cmus w3m w3m-img trash-cli atool highlight ranger calcurse light-locker light gksu synaptic
sudo pip3 install pywal
#TODO: stow qtile configs
[ -d $HOME"/bin"] || mkdir -p $HOME"/bin"
cp -fv ~/dotfiles/bin/* ~/bin/
#TODO: stow bash

#Setup ranger
#TODO: stow ranger
#Install devicons manually(?) i don't remeber if i need to install them via github or not
