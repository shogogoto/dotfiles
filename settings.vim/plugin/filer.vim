Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-mapping-git.vim' " >> staging, << unstaging
Plug 'lambdalisue/fern-bookmark.vim'
Plug 'lambdalisue/fern-mapping-mark-children.vim'
Plug 'lambdalisue/fern-mapping-project-top.vim'
Plug 'lambdalisue/fern-hijack.vim' " vi .でファイラー起動
Plug 'yuki-yano/fern-preview.vim'

Plug 'lambdalisue/nerdfont.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-renderer-devicons.vim'
Plug 'lambdalisue/glyph-palette.vim'

let g:fern#renderer = "nerdfont"
" help: Fern内で Shift+? or a help
let g:fern#default_hidden=1 " Show hidden files
nnoremap <leader>e <cmd>Fern . -reveal=% -drawer<cr>
nnoremap <leader>b <cmd>Fern bookmark:///<cr>


set guifont=DroidSansMono\ Nerd\ Font\ 11

" アイコンに色をつける
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END


function! s:fern_settings() abort
  nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)


  " nmap <silent> <buffer> T <Plug>(fern-action-project-top)
  nmap <silent> <buffer> T <Plug>(fern-action-project-top:reveal)


  nmap <silent> <buffer> t <Plug>(fern-action-mark-children)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END



function! s:init_fern() abort
  " Use 'select' instead of 'edit' for default 'open' action
  nmap <buffer> <Plug>(fern-action-open) <Plug>(fern-action-open:select)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END






" netrw設定
" https://qiita.com/gorilla0513/items/bf2f78dfec67242f5bcf
" https://pc.oreda.net/software/filer/netrw
let g:netrw_liststyle=1      " ファイルツリーの表示形式、1にするとls -laのような表示になります
let g:netrw_banner=0         " ヘッダを非表示にする
let g:netrw_sizestyle="H"    " サイズを(K,M,G)で表示する
let g:netrw_preview=1        " プレビューウィンドウを垂直分割で表示する
let g:netrw_winsize = 80     " 分割で開いたときに80%のサイズで開く
let g:netrw_liststyle = 3    " 表示形式をTreeViewに変更
let g:netrw_browse_split = 3 " Enterで、タブ表示
