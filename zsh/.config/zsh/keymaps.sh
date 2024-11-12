#!/usr/bin/env bash

function _open_with_nvim() {
  nvim
}

zle -N _open_with_nvim
bindkey '^V' _open_with_nvim
