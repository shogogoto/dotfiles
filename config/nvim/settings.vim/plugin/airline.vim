Plug 'vim-airline/vim-airline'          " option bar ステータスバーイイ感じ e.g. buffersを表示
Plug 'vim-airline/vim-airline-themes'

"vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

" nnoremap <Right> :bn<CR>
" Smarter tab line有効化
let g:airline#extensions#tabline#enabled = 1
" powerline font入れないと若干ダサい
let g:airline_powerline_fonts = 1
" vim-airline-themesが必要
let g:airline_theme='behelit'
