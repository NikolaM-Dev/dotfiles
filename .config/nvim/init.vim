" Base
so ~/.config/nvim/general/settings.vim

" General
    so ~/.config/nvim/vim-plug/plugins.vim
    so ~/.config/nvim/general/keys.vim

if exists('g:vscode')
    so ~/.config/nvim/vscode/settings.vim
    so ~/.config/nvim/plug-config/easymotion.vim
    " so ~/.config/nvim/vscode/keys.vim
else
    " Base Plugin
    so ~/.config/nvim/plug-config/coc.vim

    " Plugins
    so ~/.config/nvim/plug-config/ale.vim
    " so ~/.config/nvim/plug-config/chadtree.vim
    so ~/.config/nvim/plug-config/closetag.vim
    so ~/.config/nvim/plug-config/closetag.vim
    so ~/.config/nvim/plug-config/coc-explorer.vim
    so ~/.config/nvim/plug-config/coc-extensions.vim
    so ~/.config/nvim/plug-config/colorizer.vim
    so ~/.config/nvim/plug-config/commentary.vim
    so ~/.config/nvim/plug-config/django.vim
    " so ~/.config/nvim/plug-config/fern.vim
    so ~/.config/nvim/plug-config/fzf.vim
    so ~/.config/nvim/plug-config/indent-line.vim
    " so ~/.config/nvim/plug-config/kite.vim
    so ~/.config/nvim/plug-config/terminal.vim
    so ~/.config/nvim/plug-config/trim-whitespaces.vim
    so ~/.config/nvim/plug-config/ultisnips.vim

    " Themes
    so ~/.config/nvim/plug-config/airline.vim
    so ~/.config/nvim/general/colors.vim
    so ~/.config/nvim/themes/ayu.vim
endif
