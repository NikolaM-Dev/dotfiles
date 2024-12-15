#!/usr/bin/env bash

function _open_with_nvim() {
  nvim -c ':Telescope smart_open theme=dropdown previewer=false'
}

zle -N _open_with_nvim
bindkey '^V' _open_with_nvim
