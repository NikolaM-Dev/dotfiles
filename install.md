# Copy configs

```sh
# Go to ~/
cd

# Install OpenSSH
sudo pacman -S openssh

# Generate a new SSH key
ssh-keygen -t rsa -b 4096 -C "arch_key"

# Evaluate if the ssh server is running
eval $(ssh-agent -s)

# Add the private key to Git
ssh-add ~/.ssh/id_rsa

# Set the route
git remote set-url origin git@github.com:NikolaM-Dev/dotfiles.git

# Clone the repository
git clone git@github.com:NikolaM-Dev/dotfiles.git

# Go to ~/.dotfiles
cd dotfiles

# Make Symbolic links
ln -s ~/dotfiles/.config/qtile ~/.config
ln -s ~/dotfiles/.config/ranger ~/.config
ln -s ~/dotfiles/.config/rofi ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config
ln -s ~/dotfiles/starship.toml ~/.config
ln -s ~/dotfiles/.local/bin ~/.local/
ln -s ~/dotfiles/.xprofile ~/
ln -s ~/dotfiles/.tmux.conf ~/
ln -s ~/dotfiles/.zshrc ~/
```

# Config enviroment

```sh
# Update arch-linux
sudo pacman -Syu

# Install Tmux
sudo pacman -S tmux

# Install xsel
sudo pacman -S xsel

# Install pip
sudo pacman -S python-pip

# Install emoji-fonts
yay -S noto-fonts-emoji

# Install Starship
curl -fsSL https://starship.rs/install.sh | bash

# Install ZSH
sudo pacman -Syu zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install adds for ZSH
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

# Install packeg manager for tmux

```sh
 # Install TPM (Tmux plugin manager).
 git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

# Install Node

```sh
# Get Curl
sudo pacman -Syu curl

# Install nvm in zsh
https://github.com/nvm-sh/nvm

# If you need lts version
nvm install node --lts
```

# Install yarn and fzf package for neovim

```sh
# Install Yarn.
npm install --global yarn

# Install FZF (fuzzy finder on the terminal and used by a Vim plugin).
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
```

# Install plugins for neovim and tmux

```sh
  # Start a tmux session and install the configured plugins. You would type in
  # ` followed by I (capital i) to issue the command.
  tmux
  `I
```
