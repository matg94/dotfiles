#!/bin/bash
# Pass username as argument

sudo apt update

# Basic tools
sudo apt install curl git

# Install zsh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup vim
sudo apt install vim  

# GUI - only

# Setup x-server
sudo apt-get install xorg

# Install awesome WM
sudo apt install awesome awesome-extra

# Install nitrogen (background image)
sudo apt install nitrogen

# Setup vscode
sudo apt install ./<file>.deb
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

# Install gedit
sudo apt install gedit

# Setup browser
sudo apt install firefox

# pulse audio
# pavucontrol
# alsa-utils (alsamixer)
# gpg
# compton
# rofi
# Setup xorg in zprofile? or end of zshrc