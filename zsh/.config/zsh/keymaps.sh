#!/usr/bin/env bash

function _open_nvim() {
  nvim
}

zle -N _open_nvim
bindkey '^V' _open_nvim
