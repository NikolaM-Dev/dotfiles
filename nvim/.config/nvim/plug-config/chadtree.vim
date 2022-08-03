let g:chadtree_settings = {
      \"keymap": {
            \"toggle_version_control": [","],
            \"toggle_follow": ["F"],
      \},
      \"ignore": {
            \"name_exact": [".DS_Store", ".directory", "thumbs.db", ".git", "node_modules"],
      \},
      \"theme":{
            \"text_colour_set": "nerdtree_syntax_dark",
      \},
      \"view":
      \{
            \"width": 30
      \}
      \}

nnoremap <leader>n <cmd>CHADopen<cr>

" \"h_split": ["i"],
" \"v_split": ["s"],
" \"select": ["w"],
" \"cut": ["m"],
