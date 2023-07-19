# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

# Finder
defaults write com.apple.finder QuitMenuItem -bool true
