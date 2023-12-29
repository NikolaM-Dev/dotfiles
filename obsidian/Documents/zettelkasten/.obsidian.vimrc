" Better up/down
nmap j gj
nmap k gk

" Togge fold
exmap togglefold obcommand editor:toggle-fold
nmap zo :togglefold
nmap zc :togglefold
nmap za :togglefold

" Unfold all
exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall

" Fold all
exmap foldall obcommand editor:fold-all
nmap zM :foldall

" system clipboard
set clipboard=unnamed

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back

exmap forward obcommand app:go-forward
nmap <C-i> :forward

unmap <Space>

exmap open_switcher obcommand switcher:open
nmap <Space>ff :open_switcher

exmap follow_link obcommand editor:follow-link
nmap gd :follow_link

" better scrolling and searching with centered always
noremap <c-d> <C-d>zz
noremap <c-u> <C-u>zz
noremap <n> nzzzv
noremap <N> Nzzzv

" editor:follow-link
" editor:open-link-in-new-leaf
" editor:open-link-in-new-split
" editor:open-link-in-new-window
" editor:focus-top
" editor:focus-bottom
" editor:focus-left
" editor:focus-right
" workspace:toggle-pin
" workspace:split-vertical
" workspace:split-horizontal
" workspace:toggle-stacked-tabs
" workspace:edit-file-title
" workspace:copy-path
" workspace:copy-url
" workspace:undo-close-pane
" workspace:export-pdf
" editor:rename-heading
" workspace:open-in-new-window
" workspace:move-to-new-window
" workspace:next-tab
" workspace:goto-tab-1
" workspace:goto-tab-2
" workspace:goto-tab-3
" workspace:goto-tab-4
" workspace:goto-tab-5
" workspace:goto-tab-6
" workspace:goto-tab-7
" workspace:goto-tab-8
" workspace:goto-last-tab
" workspace:previous-tab
" workspace:new-tab
" obsidian-hider:toggle-tab-containers
" obsidian-hider:toggle-app-ribbon
" obsidian-hider:toggle-hider-status
" obsidian-style-settings:show-style-settings-leaf
" dataview:dataview-force-refresh-views
" dataview:dataview-drop-cache
" calendar:show-calendar-view
" calendar:open-weekly-note
" calendar:reveal-active-note
" obsidian-outliner:show-release-notes
" obsidian-outliner:system-info
" obsidian-outliner:move-list-item-up
" obsidian-outliner:move-list-item-down
" obsidian-outliner:indent-list
" obsidian-outliner:outdent-list
" obsidian-outliner:fold
" obsidian-outliner:unfold
" marp-slides:preview
" marp-slides:export-pdf
" marp-slides:export-pdf-notes
" marp-slides:export-html
" marp-slides:export-pptx
" marp-slides:export-png
" app:go-back
" app:go-forward
" app:open-vault
" theme:use-dark
" theme:use-light
" theme:switch
" app:open-settings
" app:show-release-notes
" markdown:toggle-preview
" markdown:add-metadata-property
" markdown:edit-metadata-property
" markdown:clear-metadata-properties
" workspace:close
" workspace:close-window
" workspace:close-others
" workspace:close-tab-group
" workspace:close-others-tab-group
" app:delete-file
" app:toggle-left-sidebar
" app:toggle-right-sidebar
" app:toggle-default-new-pane-mode
" app:open-help
" app:reload
" app:show-debug-info
" app:open-sandbox-vault
" window:toggle-always-on-top
" window:zoom-in
" window:zoom-out
" window:reset-zoom
" file-explorer:new-file
" file-explorer:new-file-in-current-tab
" file-explorer:new-file-in-new-pane
" open-with-default-app:open
" file-explorer:move-file
" file-explorer:duplicate-file
" open-with-default-app:show
" editor:open-search
" editor:open-search-replace
" editor:focus
" editor:toggle-fold-properties
" editor:toggle-fold
" editor:fold-all
" editor:unfold-all
" editor:fold-less
" editor:fold-more
" editor:insert-wikilink
" editor:insert-embed
" editor:insert-link
" editor:insert-tag
" editor:set-heading
" editor:set-heading-0
" editor:set-heading-1
" editor:set-heading-2
" editor:set-heading-3
" editor:set-heading-4
" editor:set-heading-5
" editor:set-heading-6
" editor:toggle-bold
" editor:toggle-italics
" editor:toggle-strikethrough
" editor:toggle-highlight
" editor:toggle-code
" editor:toggle-inline-math
" editor:toggle-blockquote
" editor:toggle-comments
" editor:toggle-bullet-list
" editor:toggle-numbered-list
" editor:toggle-checklist-status
" editor:cycle-list-checklist
" editor:insert-callout
" editor:insert-codeblock
" editor:insert-mathblock
" editor:swap-line-up
" editor:swap-line-down
" editor:attach-file
" editor:delete-paragraph
" editor:toggle-spellcheck
" editor:context-menu
" file-explorer:open
" file-explorer:reveal-active-file
" global-search:open
" switcher:open
" graph:open
" graph:open-local
" graph:animate
" backlink:open
" backlink:open-backlinks
" backlink:toggle-backlinks-in-document
" canvas:new-file
" canvas:export-as-image
" canvas:jump-to-group
" canvas:convert-to-file
" outgoing-links:open
" outgoing-links:open-for-current
" tag-pane:open
" properties:open
" properties:open-local
" daily-notes
" daily-notes:goto-prev
" daily-notes:goto-next
" insert-template
" insert-current-date
" insert-current-time
" note-composer:merge-file
" note-composer:split-file
" note-composer:extract-heading
" command-palette:open
" bookmarks:open
" bookmarks:bookmark-current-view
" bookmarks:bookmark-current-search
" bookmarks:unbookmark-current-view
" bookmarks:bookmark-current-section
" bookmarks:bookmark-current-heading
" bookmarks:bookmark-all-tabs
" outline:open
" outline:open-for-current
" workspaces:load
" workspaces:save-and-load
" workspaces:open-modal
" file-recovery:open
" editor:toggle-source
" obsidian-admonition:collapse-admonitions
" obsidian-admonition:open-admonitions
" obsidian-admonition:insert-admonition
" obsidian-admonition:insert-callout
