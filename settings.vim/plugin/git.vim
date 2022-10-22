Plug 'airblade/vim-gitgutter'           " Gitの変更行を表示
Plug 'tpope/vim-fugitive'

let g:gitgutter_highlight_lines = 1
nnoremap <Leader>git :GitGutterToggle<CR>
nnoremap <Leader>gith :GitGutterLineHighlightsToggle<CR>
