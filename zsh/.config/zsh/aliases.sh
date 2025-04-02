#!/usr/bin/env bash

# Configs
alias A="cd ~/.config/alacritty && nvim alacritty.toml"
alias C="cd ~/.config"
alias csessions="gio trash ~/.local/share/nvim/sessions/"
alias dbnvim="rm -rf ~/.local/share/nvim; rm -rf ~/.local/state/nvim; rm -rf ~/.cache/nvim"
alias dc="cd ~/Documents"
alias D="cd ~/dotfiles && nvim"
alias dl="cd ~/Downloads"
alias g1="cd ~/w/1-projects/"
alias g2="cd ~/w/2-areas/"
alias g3="cd ~/w/3-resources/"
alias g4="cd ~/w/4-archives/"
alias g="cd ~/Documents/drive"
alias G="cd ~/go/src/github.com/NikolaM-Dev"
alias grub-cfg="sudoedit /etc/default/grub"
alias lb="cd ~/library"
alias ncache="rm -rf ~/.cache/nvim/lazy"
alias pacman-cfg="sudoedit /etc/pacman.conf"
alias P="cd ~/Pictures"
alias R="cd ~/workspace/react"
alias sb="cd $SECOND_BRAIN_PATH && nvim"
alias ss="sudo -E -s"
alias V="cd ~/.config/nvim && nvim"
alias W="cd ~/w"
alias year='cal -mwy'
alias zc="nvim ~/.zshrc"

# Pacman
alias padd="sudo pacman -S"
alias pfind="sudo pacman -Ss"
alias prm="sudo pacman -Rsun"
alias prmu="sudo pacman -Rns $(pacman -Qtdq)"
alias pupdate="sudo pacman -Syu && yay -Syu && omz update && ysc"

# Yay
alias yadd="yay -S"
alias yfind="yay -Ss"
alias yupdate="yay -Syu; yay -Sc"
alias ysc="yay -Sc --noconfirm"

# Crud
alias ...="cd ../.."
alias ..="cd .."
alias ctrash="gio trash --empty"
alias gt="gio trash"
alias rmf="rm -rf"
alias to="touch"
alias trash="cd ~/.local/share/Trash/files"

# Git
alias ga="git add --all"
alias gb="git branch -a"
alias gca="git commit --amend"
alias gcanedit="git commit --amend --no-edit"
alias gc="git commit -m"
alias gct="git checkout"
alias gfa="git fetch --all -p -P"
alias gfresh="git reset --hard HEAD && git clean -f -d"
alias gi="git init"
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias gma="git merge --abort"
alias gmfbc="git pull origin --no-edit qa && gp"
alias gmfdev="git merge --no-ff --no-edit develop && gp"
alias gmfmain="git merge --no-ff --no-edit qa && gp"
alias gmfqa="git merge --no-ff --no-edit qa && gp"
alias gm="git merge --no-ff --no-edit"
alias gp="git push"
alias gpl="git pull"
alias gpof="git push origin -f HEAD"
alias gpo="git push origin -u HEAD"
alias gpt="git push --tags"
alias grank="git shortlog -sn --no-merges"
alias gr="git remote"
alias gs="git status -sb"
alias gsl="git stash list"
alias gst="git stash -um"
alias gsw="git switch"
alias gta="git tag -a"
alias gtl="git tag -l"

# yarn
alias yad="yarn add -D -E"
alias ya="yarn add -E"
alias yi="npm init -y"
alias yrm="yarn remove"

# Golang
alias gcoverage="go test -coverprofile=coverage.out; go tool cover -o coverage.html -html=coverage.out; google-chrome-stable coverage.html"
alias gdtelemetry="go run golang.org/x/telemetry/cmd/gotelemetry@latest off"
alias gmi="go mod init"
alias gtest="go test -v -cover ./..."

# IDE
alias cd="z"
alias compile-dwm="cd ~/.config/chadwm/chadwm && sudo make clean install && cd -"
alias cva="yarn create vite"
alias dautotime="sudo timedatectl set-ntp 0"
alias disable-suspend="sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target"
alias eautotime="sudo timedatectl set-ntp 1"
alias e="exit"
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias grep="grep --color=auto"
alias install-ex-dependencies="sudo pacman -Syu p7zip unrar tar rsync unzip"
alias keysoup="sudo systemctl restart keyd && sudo systemctl enable keyd && sudo systemctl start keyd && setxkbmap -option compose:menu"
alias l="eza -ahl --group-directories-first --icons"
alias lg="lazygit"
alias mnvmrc="node -v >> .nvmrc"
alias pdfs="~/grey/ && ranger && cd -"
alias sfeh="source ~/.fehbg"
alias sr="sudo reboot"
alias ssn="sudo shutdown now"
alias szsh="source ~/.zshrc"
alias tree="eza -hT --group-directories-first --icons"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias v=nvim
alias zt="n-open-with-zathura"

# Docker
alias dclsa="docker container ls -a"
alias dcls="docker container ls"
alias dcr="docker container run"
alias dcrm="docker container rm"
alias dcrmf="docker container rm -f"
alias dcstart="docker container start"
alias dcstop="docker container stop"
alias dilsa="docker image ls -a"
alias dils="docker image ls"
alias dirm="docker image rm"
alias dirmf="docker image rm -f"
alias dpull="docker pull"
alias dcprune="docker container prune"
alias diprune="docker image prune"

# Docker Compose
alias dcb="docker-compose build"
alias dcd="docker-compose down"
alias dcps="docker-compose ps"
alias dcu="docker-compose up"
alias dcupd="docker-compose up -d"
alias dps="docker ps"
alias ssd="systemctl start docker.service"

# Rclone
alias rcsltr="rclone -v sync /home/nikola/Documents/drive drive:"
alias rcsrtl="rclone -v sync drive: /home/nikola/Documents/drive"
alias rcp="rclone -v copy /home/nikola/Documents/drive drive:"
alias rcpl="rclone -v copy drive: /home/nikola/Documents/drive"

# Youtube
alias play="vlc -I ncurses --novideo --random --loop --playlist-autostart ."
alias ytaudio="yt-dlp -f 'ba' -x --no-playlist"
alias ytmp3="yt-dlp -x --audio-format mp3"
alias ytmp4="yt-dlp --format 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]'"
alias ytplaylist="yt-dlp -f 'ba' -x"

# Utility
alias dir-size="du -sh"

# Emacs
alias kem="killall emacs || echo 'Emacs server not running'"
alias rem="killall emacs || echo 'Emacs server not running'; /usr/bin/emacs --daemon"
