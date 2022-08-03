# Neovim

![Neovim](./neovim.png)

**_Idioma_**

- 🇪🇸 Español
- [🇺🇸 English](https://github.com/NikolaM-Dev/.doftfiles/tree/main/.config/nvim)

Para usar esta configuración, primero descarga las dependencias:

```bash
# Vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Instala solo los que no tienes
sudo pacman -S python python-pip ruby rubygems

# Paquetes de neovim
pip install neovim
python3 -m pip install --user --upgrade pynvim
pip install trash-cli
gem install neovim
sudo npm i -g neovim

# Otras dependencias
sudo pacman -S xsel fzf ripgrep fd the_silver_searcher prettier
yay -S universal-ctags-git
```

## Copia mis configuraciones:

```bash
git clone https://github.com/NikolaM-Dev/doftfiles.git
cp -r dotfiles/.config/nvim ~/.config
```

Después ejecuta `:PlugInstall` dentro de neovim.

Abre _neovim_ y ejecuta _:PlugInstall_. Cierra _neovim_, y la próxima vez
que lo abras, las configuraciones se habrán aplicado. Estos son algunos atajos
de teclado que tengo aparte de los que vienen por defecto:

| Atajo                  | Acción                                  |
| ---------------------- | --------------------------------------- |
| **ii**                 | Cambiar a modo normal (desde insertar)  |
| **alt + [hjkl]**       | Cambiar split de tamaño                 |
| **control + [hjkl]**   | Navegar splits                          |
| **space + w**          | Guardar                                 |
| **space + q**          | Salir                                   |
| **tab**                | Siguiente buffer                        |
| **shift + tab**        | Buffer previo                           |
| **control + b**        | Cerrar buffer                           |
| **shift + <** or **>** | Identar o borrar indentación (visual)   |
| **shift + k** o **j**  | Mover línea seleccionada abajo o arriba |

**_Plugins_**:

| Atajo         | Acción                                  |
| ------------- | --------------------------------------- |
| **space + f** | Búsqueda                                |
| **space + /** | Comentar la línea o bloque seleccionado |
| **space + n** | Fern                                    |
| **space + p** | Formatear documento con prettier        |
| **shift + k** | Documentación de la función o clase     |

También encontrará muchas combinaciones de teclas en el archivo `./nvim/general/keys.vim`
