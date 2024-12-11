# zmodload zsh/zprof
eval $(/opt/homebrew/bin/brew shellenv)

export EDITOR=nvim
export VISUAL=nvim


export TERM=xterm-256color
if [ -z "$TMUX" ]; then
  exec tmux new-session -A -s personal
fi

# ZSHZ
ZSHZ_DATA=$ZDOTDIR/z/.zshz
ZSHZ_TILDE=1

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

autoload -Uz compinit

() {
  if [[ $# -gt 0 ]]; then
    compinit
  else
    compinit -C
  fi
} ${ZDOTDIR}/z/.zcompdump(N.mh+24)


# History settings
HISTFILE=$ZDOTDIR/z/.history
HISTFILESIZE=1000000000 # history limit of the file on disk
HISTSIZE=1000000000 # current session's history limit
SAVEHIST=500000 # zsh saves this many lines from the in-memory history list to the history file upon shell exit
HISTTIMEFORMAT="%d/%m/%Y %H:%M] "

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt APPENDHISTORY             # ensures that each command entered in the current session is appended to the history file immediately after execution
setopt INC_APPEND_HISTORY        # history file is updated immediately after a command is entered

# Antidote
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
# source $ZDOTDIR/antidote/.antidote/antidote.zsh
# antidote bundle <$ZDOTDIR/antidote/shared_plugins.txt >$ZDOTDIR/antidote/shared_plugins.zsh
source $ZDOTDIR/antidote/shared_plugins.zsh

# Aliases
for file in "$ZDOTDIR"/aliases/*.zsh; do
  if [[ -f $file ]]; then
    source "$file"
  fi
done

# Source SSH keys
ssh_keys=(github gitlab bitbucket devops)
for n in ${ssh[@]}; do
  if [[ -f ~/.ssh/$n/$n ]]; then
    ssh-add ~/.ssh/$n/$n
  fi
done

# ASDF
. $(brew --prefix asdf)/libexec/asdf.sh
. ~/.asdf/plugins/java/set-java-home.zsh
. "/Users/btukus/.asdf/installs/rust/stable/env" 

eval "$(oh-my-posh init zsh --config ~/dotfiles/zsh/nordtron.omp.json)"

# zprof
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
