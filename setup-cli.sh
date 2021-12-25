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

# Setup vim
sudo apt install vim
cp ./dotfiles/vim/vimrc /home/$1/.vimrc
