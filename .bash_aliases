alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'

# GPG alias for prompting auth
alias gpga="echo 'gpg' | gpg -s && clear"

# Replace rm with trash-cli
alias rm="trash"

# Replace ls so that all output is human readable
alias ls="ls -lh --color=auto"
alias la="ls -lah --color=auto"

# Add some directory shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Replace df so that all output is human readable
alias df="df -h"

# Replace cp with interactive version
alias cp="cp -ir"

# Replace grep with colorized version
alias grep="grep --color=auto"

# Update all packages
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"

# Reload bash
alias reload="clear && source ~/.bashrc"

# Show open ports
alias ports="sudo lsof -i -P -n | grep -s LISTEN"

# Show public IPv4 and IPv6 addresses
alias ip="curl -s http://checkip.amazonaws.com || 'No IPv4 address found' && curl -s http://checkipv6.amazonaws.com || echo 'No IPv6 address found'"

# Show all files in current directory and subdirectories
alias tree="tree -ah -I '.git|node_modules|vendor|.idea|.vscode|.gitignore|.gitkeep|.env|.env.example|.env.*'"

# Network troubleshooting
alias ping="ping -c 5"

# Docker
alias dkill="docker kill \$(docker ps -q)"
alias dstop="docker stop \$(docker ps -q)"
alias drm="docker rm \$(docker ps -a -q)"
