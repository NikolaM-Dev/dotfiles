#!/usr/bin/env bash

# Configs
alias A="cd ~/.config/alacritty && nvim alacritty.toml"
alias C="cd ~/.config"
alias csessions="gio trash ~/.local/share/nvim/sessions/"
alias dbnvim="rm -rf ~/.local/share/nvim && rm -rf ~/.cache/nvim/lazy"
alias dc="cd ~/Documents"
alias D="cd ~/dotfiles && nvim"
alias dl="cd ~/Downloads"
alias g="cd ~/Documents/drive"
alias G="cd ~/go/src/github.com/NikolaM-Dev"
alias grub-cfg="sudo nvim /etc/default/grub"
alias lb="cd ~/library"
alias ncache="rm -rf ~/.cache/nvim/lazy"
alias pacman-cfg="sudo nvim /etc/pacman.conf"
alias P="cd ~/Pictures"
alias R="cd ~/workspace/react"
alias sb="cd ~/Documents/second-brain.md && nvim"
alias ss="sudo -E -s"
alias V="cd ~/.config/nvim && nvim"
alias W="cd ~/workspace"
alias year='cal -mwy'
alias zc="nvim ~/.zshrc"

# Pacman
alias padd="sudo pacman -S"
alias pfind="sudo pacman -Ss"
alias prm="sudo pacman -Rsun"
alias pupdate="sudo pacman -Syu && yay -Syu && omz update"

# Yay
alias yadd="yay -S"
alias yfind="yay -Ss"
alias ysc="yay -Sc"

# Crud
alias ...="cd ../.."
alias ..="cd .."
alias ctrash="gio trash --empty"
alias gt="gio trash"
alias rmf="rm -rf"
alias to="touch"
alias trash="cd ~/.local/share/Trash/files"
