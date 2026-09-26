# DOCS
# https://zsh.sourceforge.io/Doc/Release/Options.html
# https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell
#───────────────────────────────────────────────────────────────────────────────

# GENERAL
setopt INTERACTIVE_COMMENTS # comments in interactive mode, useful for copypasting
setopt GLOB_DOTS            # glob includes dotfiles
setopt PIPE_FAIL            # tracebility: exit if pipeline failed
setopt NO_BANG_HIST         # don't expand `!`

# LANGUAGE
# set English everywhere, fixes encoding issues
export LANG="en_US.UTF-8"
export LC_ALL="$LANG"
export LC_CTYPE="$LANG"
