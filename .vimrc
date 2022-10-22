" ~/.vimrcに以下を書く
" ~ source ~/dotfiles/.vimrc

" ref: https://qiita.com/ulwlu/items/98901f4c4f0683e7aa57

filetype plugin indent on
runtime macros/matchit.vim "default plugin for % command extension
syntax enable "構文ハイライトが有効

set runtimepath+=~/dotfiles/

runtime! settings.vim/basic/*.vim
runtime! settings.vim/script/*.vim

if has("vim_starting")
  set nocompatible
endif

call InstallVimPlug('~/.vim/autoload/plug.vim')

let mapleader="\<Space>"

call plug#begin(expand('~/.vim/plugged'))
  runtime! settings.vim/plugin/*.vim
  Plug 'vim-jp/vimdoc-ja'                 " 日本語ヘルプ
  Plug 'tpope/vim-commentary'             " gcc, gc motionでコメントアウト
  Plug 'bronson/vim-trailing-whitespace'  " 行末の半角スペースを可視化　:FixWhitespaceで削除
  Plug 'junegunn/vim-easy-align'          " 指定文字で整形:gaモーション  https://qiita.com/takuyanin/items/846cb2b3e541f79f0d54
  " Plug 'mattn/vim-lsp-settings'
call plug#end()



let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1  "起動時にNERDTreeを表示"
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
let NERDTreeShowHidden=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <Leader>dir :NERDTreeTabsToggle<CR>
autocmd BufWritePre * :FixWhitespace
augroup NERD
    " au!
    " autocmd VimEnter * NERDTree
    autocmd VimEnter * wincmd p
augroup END



"" quickrun  ファイルを実行
nnoremap <Leader>go :QuickRun<CR>
nnoremap <C-U>qr :QuickRun<CR>
let g:quickrun_config={'*': {'split': ''}}
let g:quickrun_config.cpp = {
            \   'command': 'g++',
            \   'cmdopt': '-std=c++11'
            \ }

"" vim-easy-align 指定文字で揃うよう整形
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"" vimshell terminalを分割画面に表示
"set splitright "右側に表示
nnoremap <Leader>sh :VimShellPop<CR>
nnoremap <Leader>sh :rightb vertical terminal<CR>
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt =  '$ '


"" vim-airline
" let g:airline#extensions#virtualenv#enabled = 1
" if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
" endif
" if !exists('g:airline_powerline_fonts')
"     let g:airline#extensions#tabline#left_sep = ' '
"     let g:airline#extensions#tabline#left_alt_sep = '|'
"     let g:airline_left_sep          = '?'
"     let g:airline_left_alt_sep      = '≫'
"     let g:airline_right_sep         = '?'
"     let g:airline_right_alt_sep     = '≪'
"     let g:airline#extensions#branch#prefix     = '?' "?, ?, ?
"     let g:airline#extensions#readonly#symbol   = '?'
"     let g:airline#extensions#linecolumn#prefix = '¶'
"     let g:airline#extensions#paste#symbol      = 'ρ'
"     let g:airline_symbols.linenr    = '?'
"     let g:airline_symbols.branch    = '?'
"     let g:airline_symbols.paste     = 'ρ'
"     let g:airline_symbols.paste     = 'T'
"     let g:airline_symbols.paste     = '∥'
"     let g:airline_symbols.whitespace = 'Ξ'
" else
"     let g:airline#extensions#tabline#left_sep = ''
"     let g:airline#extensions#tabline#left_alt_sep = ''
"     let g:airline_left_sep = ''
"     let g:airline_left_alt_sep = ''
"     let g:airline_right_sep = ''
"     let g:airline_right_alt_sep = ''
"     let g:airline_symbols.branch = ''
"     let g:airline_symbols.readonly = ''
"     let g:airline_symbols.linenr = ''
" endif

"
colorscheme molokai
