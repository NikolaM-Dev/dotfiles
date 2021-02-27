# Ignore this readme, it's under construction :construction_worker:

# Copy configs

```sh
 # Go to ~/
 cd

 # Clone the repository
 git clone https://github.com/NikolaM-Dev/.dotfiles.git

 # Go to ~/.dotfiles
 cd .dotfiles

 # Make Symbolic links
 ln -s ~/.dotfiles/.vim ~/
 ln -s ~/.dotfiles/.vimrc ~/
 ln -s ~/.dotfiles/.tmux.conf ~/
 ln -s ~/.dotfiles/.zshrc ~/
 ln -s ~/.dotfiles/nvim ~/.config/
 ln -s ~/.dotfiles/ranger ~/.config/
 ln -s ~/.dotfiles/qtile ~/.config/
 ln -s ~/.dotfiles/alacritty ~/.config/
```

# Config Enviroment

```sh
 # Update manjaro
 sudo pacman -Syu

 # Install neovim
 sudo pacman -Syu neovim
 sudo pacman -S python-pynvim

 # Install Tmux
 sudo pacman -Syu tmux

 # Install xsel
 sudo pacman -Syu xsel

 # Install ZSH
 sudo pacman -Syu zsh

 # Install Oh My Zsh
 sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

 # Install adds for ZSH
 git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
 git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

 # Config zsh addons, modify the `~/.zshrc` config file editing plugins section like this:
 nano ~/.zshrc

 plugin=(
	git
	zsh-autosuggestions
        zsh-syntax-highlighting
 )

 # Apply changes in `~/.zshrc`
 source ~/.zshrc
```

# Install packeg manager for neovim and tmux

```sh
 # Install TPM (Tmux plugin manager).
 git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

 # Install Plug (Neovim plugin manager).
 sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

# Install NodeJS

```sh
 # Get Curl
 sudo pacman -Syu curl

 # Install nvm in zsh
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh

 # Restart terminal
 zsh

 # Install node
 nvm install node

 # If you need lts version
 nvm install node --lts
```

# Install yarn, fzf(for Neovim) and node's package for neovim.

```sh
 # Install Yarn.
 npm install --global yarn

 # Install FZF (fuzzy finder on the terminal and used by a Vim plugin).
 git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

 # NodeJS provider
 npm install -g neovim
```

# Install plugins for neovim and tmux

```sh
  # Open Vim and install the configured plugins. You would type in the
  # :PlugInstall command from within Vim and then hit enter to issue the command.
  nvim .
  :PlugInstall

  # Start a tmux session and install the configured plugins. You would type in
  # ` followed by I (capital i) to issue the command.
  tmux
  `I
```

# Nerd Fonts for programmers

```sh
 # Cascadia Code
 https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/CascadiaCode/complete/Caskaydia%20Cove%20Regular%20Nerd%20Font%20Complete.ttf

 # JetBrains Mono
 https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono
```
