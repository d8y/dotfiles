#!/usr/bin/env bash

CURRENT_DIR=`pwd`

ln -fsv "$CURRENT_DIR/.zshrc" ~/.zshrc
DIRECTORY=zsh
ln -fsv "$CURRENT_DIR/$DIRECTORY/.zshrc.local" ~/.zshrc.local

if [ ! -d ~/$DIRECTORY ]; then
  mkdir ~/$DIRECTORY
fi

for file in $DIRECTORY/*.zsh; do
  ln -fsv $CURRENT_DIR/$file ~/$file
done

# Setup .claude directory
CLAUDE_DIR=.claude
if [ ! -d ~/$CLAUDE_DIR ]; then
  mkdir -p ~/$CLAUDE_DIR/scripts
fi

ln -fsv "$CURRENT_DIR/$CLAUDE_DIR/settings.json" ~/$CLAUDE_DIR/settings.json
ln -fsv "$CURRENT_DIR/$CLAUDE_DIR/scripts/deny-check.sh" ~/$CLAUDE_DIR/scripts/deny-check.sh