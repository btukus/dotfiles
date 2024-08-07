# ls aliases
alias la='eza -la --group-directories-first --git'
alias laa='eza -la --group-directories-first --absolute --git'
alias lar='eza -la --group-directories-first --recurse --git'
alias lg='la | grep'

# Directory changes
alias cdb='cd -'
alias GD='temp=$(pwd)'
alias cdt='cd $temp'
alias path="sed 's/:/\n/g' <<< "$PATH""

# Navigation aliases
alias hd='cd ~'
alias win='cd /mnt/c/Users/BTUKUS/Desktop'

# Dotfiles
alias dot='cd ~/dotfiles'
alias bw='cd ~/dotfiles/brew'
alias tm='cd ~/dotfiles/config/.config/tmux'

# Shell aliases
alias su='source $ZDOTDIR/.zshrc'
alias sl='cd ~/dotfiles/zsh'

# Neovim aliases
alias f='nvim'
alias ff='file=$(fzf --preview "bat --style=grid --color=always {}") && [ -n "$file" ] && nvim "$file"'
alias fs='nvim --startuptime /tmp/nvim-startuptime'
alias nc='cd ~/dotfiles/config/.config/nvim/'
alias ncc='cd ~/dotfiles/config/.config/nvim/lua/core'
alias ncp='cd ~/dotfiles/config/.config/nvim/lua/plugins'
alias lsp='cd ~/dotfiles/config/.config/nvim/lua/plugins/lsp'

# Vim aliases
alias vim='vim -u ~/.config/vim/vimrc'

# Misc
alias RM='sudo rm -r'

# Find
alias ffn='find . -name'
alias ffd='find . -d'

# SSH keys add
alias gh='ssh-add ~/.ssh/github/github'
alias glab='ssh-add ~/.ssh/gitlab/gitlab'
alias devops='ssh-add ~/.ssh/devops/devops'
alias sshdevops='ssh-add ~/.ssh/sshdevops/sshdevops'

alias cpr='cp -r'

alias ds='clear'
alias cls='clear'
alias cl='clear'
