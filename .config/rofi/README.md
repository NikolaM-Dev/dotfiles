# Rofi

![Rofi](./rofi.png)

**_Language_**

- [🇪🇸 Español](./README.es.md)
- 🇺🇸 English

## Install rofi and dependencies:

```bash
sudo pacman -S rofi papirus-icon-theme
```

## Neccessary font:

Download [**JetBrains**](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip) font in `~/Downloads`

```sh
# ~/Downloads
sudo pacman -S unzip
unzip JetBrainsMono.zip
sudo mv *.ttf /usr/share/fonts
```

## Copy my configs:

```bash
git clone https://github.com/NikolaM-Dev/.doftfiles.git
cp -r .dotfiles/.config/rofi ~/.config
```

If you are using my window manager configs, **mod + m** will launch
_rofi -show drun_ (menu) and **mod + shift + m** will launch _rofi -show_ (window navigation).
