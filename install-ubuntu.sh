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

#Install base software #kvantum-qt5 kvantum-theme-arc <--- missing packages #Timeshift and pyroom missing in ubuntu
sudo apt install gnome-screenshot gnome-calculator xfburn redshift redshift-gtk gimp pinta ristretto vlc quodlibet firefox thunderbird filezilla hexchat qbittorrent wireshark mpv vlc simplescreenrecorder screenkey quodlibet easytag libreoffice vim-gtk retext evince zathura mupdf arc-theme numix-gtk-theme baobab curl dconf-editor gnome-disk-utility gnome-system-monitor gnome-terminal gparted grsync gvfs htop lsb-release mlocate net-tools notify-osd fonts-noto numlockx neofetch scrot simple-scan thunar thunar-archive-plugin thunar-volman pcmanfm tumbler wget unace unrar zip unzip sharutils uudeview arj cabextract file-roller keepass2 ntfs-3g 

#install proprietary software
sudo apt install discord gitkraken
sudo snap install --classic visual-studio-code

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
cdc ..
git clone https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh Hack 
cd ~
#TODO: stow .Xresources

#Set up ZSH
sudo apt install zsh zsh-dev zsh-doc tig
#sudo usermod -s /bin/zsh $(whoami)
## Install oh my zsh
cd ~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &
wait
[ -d $HOME"/.oh-my-zsh" ] || echo "### OH MY ZSH DIR NOT FOUND!" ; exit 1

 #Remove .zshrc created by .oh-my-zsh!
rm -v ~/.zshrc
#TODO: stow zshrc
rm -v ~/.oh-my-zsh/oh-my-zsh.zsh
rm -v ~/.oh-my-zsh/custom/example.zsh
cp -v ~/dotfiles/oh-my-zsh/.oh-my-zsh/oh-my-zsh.zsh ~/.oh-my-zsh/
cp -v ~/dotfiles/oh-my-zsh/.oh-my-zsh/custom/example.zsh ~/.oh-my-zsh/custom/
cp -v ~/dotfiles/oh-my-zsh/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#Set up Vim
#TODO: stow vimrc



#Set up QTile
sudo apt install qtile
sudo apt install network-manager-gnome redshift redshift-gtk feh nitrogen syncthing maim notify-osd suckless-tools firefox cmus w3m w3m-img trash-cli atool highlight ranger calcurse light-locker synaptic
cd ~
wget https://github.com/haikarainen/light/releases/download/v1.2/light_1.2_amd64.deb
dpkg -i light_1.2_amd64.deb
sudo pip3 install pywal 
#TODO: stow qtile configs
[ -d $HOME"/bin"] || mkdir -p $HOME"/bin"
cp -fv ~/dotfiles/bin/* ~/bin/
sudo chmod +x ~/bin/*
#TODO: stow bash
#Setup ranger
#TODO: stow ranger
#Install devicons manually(?) i don't remeber if i need to install them via github or not

[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
cp -rv ~/dotfiles/resources/icons/AwOkenWhite ~/.icons/
cp -v ~/dotfiles/resources/scripts/git_setup_public.sh

echo "installation almost done: write your credentials inside the scipt git_setup_public.sh and run it to setup your git account"

#I have no idea of how Screen Locking might work for now, will modify installer again. 

