#!/usr/bin/env bash

echo "Copying \".stow-global-ignore\" file to $HOME"
cp ./.stow-global-ignore ~/

echo ""
echo "Recreating the tree of elements with stow"
make