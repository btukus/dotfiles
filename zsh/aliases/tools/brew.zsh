alias bwi='brew install'
alias bic='brew install --cask'
alias br='brew reinstall'
alias bu='brew uninstall'

# Brewfile
alias brew-export-mac='brew bundle dump --file=~/dotfiles/brew/Brewfile.macos --force && sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.macos'
alias brew-export-linux='brew bundle dump --file=~/dotfiles/brew/Brewfile.linux --force && sed -i "" "/^vscode/d" ~/dotfiles/brew/Brewfile.linux'
