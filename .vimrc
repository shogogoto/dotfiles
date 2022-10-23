" ~/.vimrcに以下を書く
" ~ source ~/dotfiles/.vimrc

" ~/.config/init.vimに以下を書く
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

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


colorscheme molokai
