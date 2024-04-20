# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
PATH="$HOME/bin:$HOME/.local/bin:$PATH"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Path to your oh-my-zsh installation.
export ZSH="/home/nikola/.oh-my-zsh"

# Golang
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH="$PATH:$HOME/go/bin"

# Rust
export PATH="$PATH:$HOME/.cargo/env"

# Deno
export DENO_INSTALL="/home/nikola/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Bun
export BUN_INSTALL="/home/nikola/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Bun completions
[ -s "/home/nikola/.bun/_bun" ] && source "/home/nikola/.bun/_bun"

# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="nanotech"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
ZSH_DISABLE_COMPFIX="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  bun
  fast-syntax-highlighting
  fnm
  fzf
  sudo
  vi-mode
  zsh-autocomplete
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR="nvim"
export FILE="ranger"
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export READER="zathura"
export TERMINAL="alacritty"
export VISUAL="nvim"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

function open_nvim {
  if [ $# -eq 0 ]; then
    nvim .
  else
    nvim $1
  fi
}

function setup-work-user {
  echo '[user]\nname = juan.merchan\nemail = juan.merchan@parqco.com' >> .git/config
}

function c {
  if [ $# -eq 0 ]; then
    code .
  elif [ $# -eq 2 ]; then
    code $1 $2
  else
    code $1
  fi
}

function gd {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}

function cdir {
  if [ $# -eq 1 ]; then
    mkdir $1 && cd $1
  else
    echo "Use: cdir <file_name>"
  fi
}

function gundo {
  if [ $# -gt 1 ]; then
    echo "Use: gundo || gundo <number_of_commits>"
  elif [ $# -eq 1 ]; then
    git reset --soft HEAD~$1
  else
    git reset --soft HEAD~1
  fi
}

function backup-commit {
    cd ~/Documents/second-brain.md

    time_stamp=$(date '+%Y-%m-%d %H:%M:%S')
    git add . && git commit -m "feat: Add backup $time_stamp" && git push origin HEAD

    cd -
}

function schange-date {
  if [ $# -eq 1 ]; then
    HOUR=$(date +%H:%M:%S)
    sudo timedatectl set-ntp 0 && sudo timedatectl set-time "$1 $HOUR"
  else
    echo "Use: schange-date <yyyy-MM-dd>"
  fi
}

function nvims() {
  items=("default" "adi" )
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $config ]]; then
    echo "Nothing selected"

    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi

  NVIM_APPNAME=$config nvim $@
}

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
function ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

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
alias grub-cfg="nvim /etc/default/grub"
alias ncache="rm -rf ~/.cache/nvim/lazy"
alias pacman-cfg="nvim /etc/pacman.conf"
alias P="cd ~/Pictures"
alias R="cd ~/workspace/react"
alias sb="cd ~/Documents/second-brain.md && nvim"
alias ss="sudo -E -s"
alias V="cd ~/.config/nvim && nvim"
alias W="cd ~/workspace"
alias zc="nvim ~/.zshrc"

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
alias gb="git branch"
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
alias go=richgo
alias grep="grep --color=auto"
alias install-ex-dependencies="sudo pacman -Syu p7zip unrar tar rsync unzip"
alias keysoup="sudo systemctl restart keyd && sudo systemctl enable keyd && sudo systemctl start keyd && setxkbmap -option compose:menu"
alias l="exa -lah --group-directories-first --icons"
alias lg="lazygit"
alias mnvmrc="node -v >> .nvmrc"
alias pdfs="~/grey/ && ranger && cd -"
alias r="ranger"
alias sr="sudo reboot"
alias ssn="backup-commit && sudo shutdown now"
alias szsh="source ~/.zshrc"
alias tree="exa -T"
alias t="tmux"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias update="sudo pacman -Syyu --noconfirm && yay -Syu --noconfirm && omz update"
alias v=nvim

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
alias ytplaylist="yt-dlp -f 'ba' -x"

# vi-mode plugin
export VI_MODE_SET_CURSOR=true
export KEYTIMEOUT=20

# Promt
eval "$(starship init zsh)"

# Crowbar
ctrlz() {
  if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
  else
    zle push-input
  fi
}
zle -N ctrlz
bindkey '^Z' ctrlz

# tmux
[[ $TMUX = "" ]] && export TERM="xterm-256color"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{node_modules/*,.git/*,plugged/*,vscode/*}"'

# fnm
export PATH="/home/nikola/.local/share/fnm:$PATH"
eval "`fnm env`"

# zoxide
eval "$(zoxide init zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
