#!/bin/bash
# Pass username as argument

sudo apt update

# Basic tools
sudo apt install curl git

# Install zsh
sudo apt install zsh
sudo chsh -s /bin/zsh $1
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ./dotfiles/zsh/zshrc /home/$1/.zshrc

# Install awesome WM
sudo apt install awesome awesome-extra

# Install nitrogen (background image)
sudo apt install nitrogen

# Setup vim
sudo apt install vim
cp ./dotfiles/vim/vimrc /home/$1/.vimrc

# GUI - only

# Setup vscode
sudo apt install ./<file>.deb
sudo apt install apt-transport-https
sudo apt update
sudo apt install code

# Install awesome WM
sudo apt install awesome awesome-extra

# Install nitrogen (background image)
sudo apt install nitrogen

# Install gedit
sudo apt install gedit

# Setup browser
sudo apt install firefox