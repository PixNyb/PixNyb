#!/bin/bash

# Color codes
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
GRAY="\033[1;90m"
NC="\033[0m"

load_theme_color() {
    # If this is the first time this bashrc is run, pick a random theme color and store it in a file
    if [ ! -f "$HOME/.theme" ]; then
        local colors=("$RED" "$GREEN" "$YELLOW" "$BLUE" "$PURPLE" "$CYAN")
        local random_color=${colors[$RANDOM % ${#colors[@]}]}
        echo $random_color > "$HOME/.theme"
        THEME_COLOR=$random_color
    fi

    THEME_COLOR=$(cat "$HOME/.theme")
}

# Check if terminal supports color
check_color_support() {
    if ! [ -x /usr/bin/tput ] || ! tput setaf 1 >&/dev/null; then
        RED=""
        GREEN=""
        YELLOW=""
        THEME_COLOR=""
        GRAY=""
        NC=""
    fi
}

# Start gpg agent
start_gpg_agent() {
    # Start the gpg and ssh agents
    if [ ! $(pgrep -u "$USER" gpg-agent) ] >/dev/null; then
        gpg-agent --daemon &>/dev/null
    fi

    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval $(ssh-agent -s) &>/dev/null
    fi

    eval $(/usr/bin/keychain --eval --nogui --agents gpg,ssh --inherit any -q $(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d'/' -f2))
    source ~/.keychain/$HOSTNAME-sh
}

# Check if git signing is enabled
check_secure_commits() {
    if ! git config --get commit.gpgsign >/dev/null 2>&1; then
        echo -e "${RED}Git signing is not enabled. Please run 'git config --global commit.gpgsign true'${NC}"
    fi
}

# Load custom aliases
load_custom_aliases() {
    [ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
}

# Set PS1 prompt
set_custom_prompt() {
    PS1="\[${THEME_COLOR}\]\u\[${GRAY}\]@\[${THEME_COLOR}\]\h \W \[${GRAY}\]$\[${NC}\] "
}

# Initialize ASDF configuration
initialize_asdf() {
    export ASDF_DIR="$HOME/.asdf"
    . $ASDF_DIR/asdf.sh
    . $ASDF_DIR/completions/asdf.bash

    [ -f "$ASDF_DIR/plugins/java/set-java-home.bash" ] && . $ASDF_DIR/plugins/java/set-java-home.bash

    [ -f "$ASDF_DIR/plugins/dotnet/set-dotnet-env.bash" ] && . $ASDF_DIR/plugins/dotnet/set-dotnet-env.bash

    PATH="$PATH:$HOME/.local/bin:$ASDF_DIR/bin:$ASDF_DIR/shims"

    [ -d "$ASDF_DIR/installs/dotnet" ] && {
        dotnet_version=$(asdf current dotnet 2>&1 | awk '{print $2}')
        export DOTNET_MSBUILD_SDK_RESOLVER_SDKS_DIR="$ASDF_DIR/installs/dotnet/$dotnet_version/sdk/*/Sdks"
        export DOTNET_MSBUILD_SDK_RESOLVER_SDKS_VER=$dotnet_version
        export DOTNET_MSBUILD_SDK_RESOLVER_CLI_DIR="$ASDF_DIR/installs/dotnet/$dotnet_version"
    }
}

# Set environment variables
set_environment_variables() {
    export EDITOR=vim
    export GPG_TTY=$(tty)
    export VCPKG_ROOT=/opt/vcpkg
    export XDG_RUNTIME_DIR=/tmp/runtime-pixnyb
    export RUNLEVEL=3
    export XDG_SESSION_TYPE=x11
    export LIBGL_ALWAYS_INDIRECT=1
    export DISPLAY=localhost:10.0
}

# Main execution
load_theme_color
check_color_support
check_secure_commits
load_custom_aliases
set_custom_prompt
initialize_asdf
set_environment_variables

# Set GIT_SSH_COMMAND
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa -o IdentitiesOnly=yes"
