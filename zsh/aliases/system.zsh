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

# Shell aliases
alias su='source $ZDOTDIR/.zshrc'
alias zs='nvim ~/dotfiles/zsh/.zshrc'
alias alac='nvim ~/dotfiles/config/.config/alacritty/alacritty.toml'

# Neovim aliases
alias f='nvim'
alias ff='file=$(fzf --preview "bat --style=grid --color=always {}") && [ -n "$file" ] && nvim "$file"'
alias fs='nvim --startuptime /tmp/nvim-startuptime'

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

function kubectl() {
  export KUBECTL_ACTIVE="true"
  command kubectl "$@"
  unset KUBECTL_ACTIVE
}
