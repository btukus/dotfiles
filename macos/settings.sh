# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

# Finder
defaults write com.apple.finder QuitMenuItem -bool true

# Remove the CMD + H shortcut for hide
defaults write -g NSUserKeyEquivalents -dict-add "Hide" '\0'
