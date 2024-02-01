#!/bin/bash

#########################################################
# Bash script to install apps on a new system using apt #
#########################################################

# Update package lists
sudo apt remove git -y
sudo add-apt-repository ppa:git-core/ppa -y
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
    git config --global push.autoSetupRemote true
    git config --global rebase.autoStash true
    git config --global core.editor "vim"
    git config --global core.excludesfile ~/.gitignore_global
}

setup_gpg() {
    # Setup a gpg key
    gpg --full-gen-key --batch <(echo "Key-Type: 1"; \
        echo "Key-Length: 4096"; \
        echo "Subkey-Type: 1"; \
        echo "Subkey-Length: 4096"; \
        echo "Expire-Date: 0"; \
        echo "Name-Real: Roël Couwenberg"; \
        echo "Name-Email: contact@roelc.me"; \
        echo "%no-protection"; )

    KEYID=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d'/' -f2)

    git config --global user.signingkey $KEYID
}

# Install apps
install_docker
install_asdf
install_trunk_cli
setup_git

# Ask if the user wants to set up gpg commit signing
read -p "Set up gpg commit signing? (y/n) " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_gpg

    echo "GPG $KEYID:"
    gpg --armor --export $KEYID
fi

# Ask if the user wants to set up wakatime time tracking
read -p "Set up wakatime time tracking? (y/n) " -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter your wakatime api key: "

    # Insert the api key into the wakatime config file
    echo "
[settings]
api_key = $REPLY
" >> ~/.wakatime.cfg
fi