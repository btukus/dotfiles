FROM homebrew/brew:latest

RUN sudo apt update && sudo apt upgrade -y
RUN sudo apt-get install build-essential -y

RUN git clone https://github.com/btukus/dotfiles ~/dotfiles
RUN cd dotfiles && bash ~/dotfiles/install.sh
RUN nvim +PackerSync +qa


ENTRYPOINT ["tail", "-f", "/dev/null"]
