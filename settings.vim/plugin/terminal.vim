Plug 'voldikss/vim-floaterm'

" Configuration example
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_new    = '<Leader>ft'
let g:floaterm_autoclose     = 1
let g:floaterm_width         = 0.8
let g:floaterm_height        = 0.8



" https://github.com/fannheyward/coc-terminal
nnoremap <silent> <space>sh <Cmd>CocCommand terminal.Toggle<CR>
" nmap <space>s <Cmd>CocCommand terminal.Toggle<CR>
" <Cmd>CocCommand terminal.Toggle<CR>
