#!/usr/bin/env bash

CURRENT_DIR=`pwd`

ln -fsv "$CURRENT_DIR/.zshrc" ~/.zshrc
DIRECTORY=zsh

if [ ! -d ~/$DIRECTORY ]; then
  mkdir ~/$DIRECTORY
fi

for file in $DIRECTORY/*.zsh; do
  ln -fsv $CURRENT_DIR/$file ~/$file
done