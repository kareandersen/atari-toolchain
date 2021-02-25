FROM ubuntu:latest
ARG user
ENV USER=$user

RUN apt-get -y update && apt-get -y install wget build-essential python3-pip upx
RUN pip3 install pypng
RUN wget -q http://vincent.riviere.free.fr/apt/vincent-riviere-apt.gpg -O /etc/apt/trusted.gpg.d/vincent-riviere-apt.gpg
RUN echo "deb [arch=amd64] http://vincent.riviere.free.fr/apt/ buster contrib\ndeb-src http://vincent.riviere.free.fr/apt/ buster contrib" >> /etc/apt/sources.list

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get install -y cross-mint-essential

WORKDIR /usr/local/src
RUN wget http://sun.hasenbraten.de/vasm/release/vasm.tar.gz
RUN tar -zxvf vasm.tar.gz
RUN wget http://sun.hasenbraten.de/vlink/release/vlink.tar.gz
RUN tar -zxvf vlink.tar.gz

WORKDIR /usr/local/src/vasm
RUN make CPU=m68k SYNTAX=mot

RUN mkdir -p /opt/vbcc/bin
RUN cp vasmm68k_mot /opt/vbcc/bin
RUN cp vobjdump /opt/vbcc/bin

WORKDIR /usr/local/src/vlink
RUN make
RUN cp vlink /opt/vbcc/bin

RUN apt-get install -y zsh git neovim
RUN useradd -m "${USER}"
WORKDIR /home/${USER}
USER ${USER}

RUN sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN wget -q https://raw.githubusercontent.com/sainnhe/dotfiles/master/.zsh-theme-gruvbox-material-dark -o $HOME/.oh-my-zsh/custom/zsh-theme-gruvbox-material-dark
COPY zsh/zshrc .zshrc
COPY zsh/p10k.zsh .p10k.zsh

COPY ./vim/nvimrc .config/nvim/init.vim
COPY ./vim/vimrc .vimrc
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
RUN vim -c 'PluginInstall' -c 'qa!'

WORKDIR /home/${USER}
ENTRYPOINT ["/usr/bin/zsh"]

