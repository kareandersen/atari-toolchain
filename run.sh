docker rm atari-toolchain
docker run -v $HOME/.gitconfig:$HOME/.gitconfig -v $HOME/.ssh:$HOME/.ssh -v $HOME/src:$HOME/src -v $HOME/ATARI:$HOME/ATARI --name=atari-toolchain -it -d  atari-toolchain 
docker attach atari-toolchain
