Plug 'haya14busa/vim-asterisk'  " アスタリスク検索強化

" fzfの使い方 CLI
" vim **<Tab>
" <Ctrl-r> 履歴から
Plug 'thinca/vim-qfreplace'
Plug 'rhysd/migemo-search.vim'
if executable('cmigemo')
    cnoremap <expr><CR> migemosearch#replace_search_word()."\<CR>"
endif


" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" fzf settings
let $FZF_DEFAULT_OPTS="--layout=reverse"
let $FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git/**'"
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }

let mapleader = "\<Space>"

" fzf
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :GFiles<CR>
nnoremap <silent> <leader>G :GFiles?<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>r :Rg<CR>


" Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

" " Insert mode completion
" imap <C-x><C-k> <plug>(fzf-complete-word)
" imap <C-x><C-f> <plug>(fzf-complete-path)
" imap <C-x><C-l> <plug>(fzf-complete-line)

" " https://github.com/yuki-yano/fzf-preview.vim
" nmap <Leader>f [fzf-p]
" xmap <Leader>f [fzf-p]

" nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>
" nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatusRpc<CR>
" nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActionsRpc<CR>
" nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffersRpc<CR>
" nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffersRpc<CR>
" nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>
" nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumpsRpc<CR>
" nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChangesRpc<CR>
" nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
" nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
" nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrepRpc<Space>
" xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrepRpc<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
" nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTagsRpc<CR>
" nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFixRpc<CR>
" nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationListRpc<CR>

" Base Fzf window Keymaps
" <C-g>, <Esc> Cancel fzf
" <C-x> Open split
" <C-v> Open vsplit
" <C-t> Open tabedit
" <C-o>
"   Jump to buffer if already open. See :drop.
"   If g:fzf_preview_buffers_jump is set to 1 then it will open the buffer in
"   current window instead.
" <C-q>
"   Build QuickFix in open-file processes.
"   Execute :bdelete! command from open-buffer and open-bufnr processes.
" <C-d> Preview page down
" <C-u> Preview page up
" ? Toggle display of preview screen
