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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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

function gbp {
  for branch in $(git branch --merged develop | egrep -v "(^\*| main| develop| qa| release)"); do
      git branch -d $branch
  done
}

function gbp2 {
  for branch in $(git branch --merged main | egrep -v "(^\*| main| develop| qa| release)"); do
      git branch -d $branch
  done
}

function gd {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock" | delta --side-by-side
}

## Change remote to ssh
function change-remote-to-ssh {
  if [[ "$#" -ne 1 ]]; then
      echo "Usage: $0 <project_name_in_github>"

      return
  fi

  git remote remove origin
  git remote add origin git@github.com:NikolaM-Dev/$1.git
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

function backup-system {
    time_stamp=$(date '+%Y-%m-%d %H:%M:%S')
    sudo timeshift --create --comments "Backup $time_stamp"
}

function schange-date {
  if [ $# -eq 1 ]; then
    HOUR=$(date +%H:%M:%S)
    sudo timedatectl set-ntp 0 && sudo timedatectl set-time "$1 $HOUR"
  else
    echo "Use: schange-date <yyyy-MM-dd>"
  fi
}

function nvims {
  items=("default" "adi" )
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config   " --height=~50% --layout=reverse --border --exit-0)

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
function ex {
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

function working-directories {
  mkdir -p ~/Documents/second-brain.md
  mkdir -p ~/go/src/github.com/NikolaM-Dev
  mkdir -p ~/library
  mkdir -p ~/Pictures
  mkdir -p ~/Videos
  mkdir -p ~/workspace/open-source
  mkdir -p ~/workspace/work
}

function y {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

	yazi "$@" --cwd-file="$tmp"

	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi

	rm -f -- "$tmp"
}

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

[[ -f ~/.config/zsh/aliases.sh  ]] && source ~/.config/zsh/aliases.sh
[[ -f ~/.config/zsh/functions.sh  ]] && source ~/.config/zsh/functions.sh
[[ -f ~/.config/zsh/keymaps.sh  ]] && source ~/.config/zsh/keymaps.sh

n-mortality
