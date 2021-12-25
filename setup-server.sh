#!/bin/bash
# Pass username as argument

sudo apt-get update -y
sudo apt-get upgrade -y

# Basic tools
sudo apt-get install net-tools sudo open-ssh -y

# Security
sudo apt-get install fail2ban -y

# Install zsh
sudo apt-get install zsh -y
sudo chsh -s /bin/zsh $1
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp ./dotfiles/zsh/zshrc /home/$1/.zshrc

# Setup vim
sudo apt-get install vim -y
cp ./dotfiles/vim/vimrc /home/$1/.vimrc
