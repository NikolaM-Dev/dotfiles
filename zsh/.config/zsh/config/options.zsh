# Shell behavior flags, sourced early. See CONFIG_FILES order in .zshrc.
# DOCS
# https://zsh.sourceforge.io/Doc/Release/Options.html
# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
#───────────────────────────────────────────────────────────────────────────────

# GENERAL
setopt GLOB_DOTS            # glob includes dotfiles
setopt INTERACTIVE_COMMENTS # comments in interactive mode, useful for copypasting
setopt NO_BANG_HIST         # don't expand `!`
setopt PIPE_FAIL            # tracebility: exit if pipeline failed

# LANGUAGE
# set English everywhere, fixes encoding issues
export LANG="en_US.UTF-8"
export LC_ALL="$LANG"
export LC_CTYPE="$LANG"
