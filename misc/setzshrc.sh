rm ~/.zshrc
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc

sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
