#!/bin/bash

#########################################################
# Bash script to install apps on a new system using apt #
#########################################################

# Update package lists
sudo apt update -y && sudo apt upgrade -y

# Install git
sudo apt install git -y

# Install tree
sudo apt install tree -y

# Install ping
sudo apt install iputils-ping -y

install_docker() {
    # Install docker if it's not already installed
    if ! [ -x "$(command -v docker)" ]; then
        echo "Installing docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
    fi
}

install_asdf() {
    # Install asdf if it's not already installed
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
}

install_trunk_cli() {
    # Prompt the user whether to install trunk or not
    read -p "Install trunk? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Install trunk
        curl https://get.trunk.io -fsSL | bash -s -- -y
    fi
}

setup_git() {
    # Setup git config
    git config --global user.name "PixNyb"
    git config --global user.email "contact@roelc.me"
    git config --global commit.gpgsign true
    git config --global commit.template ~/.gitmessage
    git config --global init.defaultBranch main
    git config --global pull.rebase true
    git config --global rebase.autoStash true
    git config --global core.editor "vim"
    git config --global core.excludesfile ~/.gitignore_global
}

# Install apps
install_docker
install_asdf
install_trunk_cli
setup_git

echo "Done, please don't forget to set up ssh commit signing:\nhttps://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification"