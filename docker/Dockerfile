FROM homebrew/brew:latest

RUN brew install git

RUN git clone https://github.com/btukus/dotfiles ~/dotfiles

# RUN ls -la ~/dotfiles/zsh
RUN bash ~/dotfiles/brew_install.sh
RUN bash ~/dotfiles/install.sh


ENTRYPOINT ["tail", "-f", "/dev/null"]
