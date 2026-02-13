# List available recipes
default:
    just --list

# Add symlinks for all configs to your home directory
# This creates symlinks in ~ based on the directories in this repo
# Example: add → ~/.config/qtile, ~/.vim, etc.
add:
    cp ./.stow-global-ignore $HOME
    stow --verbose --target=$HOME --restow */

# Remove symlinks - cleans up the configs
# This deletes the symlinks from your home directory
delete:
    stow --verbose --target=$HOME  --delete */
