# Rofi

![Rofi](./rofi.png)

**_Idioma_**

- 🇪🇸 Español
- [🇺🇸 English](https://github.com/NikolaM-Dev/.doftfiles/tree/main/.config/rofi)

Instala _rofi_ y las dependencias:

```sh
sudo pacman -S rofi papirus-icon-theme
```
Fuente necesaria:
<br>
Descarga la fuente de [**JetBrains**](https://github.com/ryanoasis/\
nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip) en `~/Downloads`

```sh
# ~/Downloads
sudo pacman -S unzip
unzip JetBrainsMono.zip
sudo mv *.ttf /usr/share/fonts
```
Copia mis configuraciones:

```bash
git clone https://github.com/NikolaM-Dev/.doftfiles.git
cp -r .dotfiles/rofi ~/.config
```

Si estás usando mis configuraciones, **mod + m** lanzará
_rofi -show drun_ (menu) y **mod + shift + m** lanzará _rofi -show_
(navegación de ventanas).