FROM homebrew/brew:latest

RUN brew install git

RUN git clone https://github.com/btukus/dotfiles ~/dotfiles
RUN bash ~/dotfiles/install.sh


ENTRYPOINT ["tail", "-f", "/dev/null"]
