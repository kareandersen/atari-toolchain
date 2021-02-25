#!/bin/sh
docker rm atari-toolchain
docker build --build-arg=user=nerve . -t atari-toolchain
