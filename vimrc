" ~/.vimrcに以下を書く
" ~ source ~/dotfiles/.vimrc

" ~/.config/nvim/init.vimに以下を書く
" -> 環境変数でdotfiles配下の設定を見に行くように変更したため不要
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
  runtime! config/nvim/settings.vim/plugin/*.vim
  Plug 'vim-jp/vimdoc-ja'                 " 日本語ヘルプ
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
call plug#end()

"" quickrun  ファイルを実行
nnoremap <Leader>go :QuickRun<CR>
nnoremap <C-U>qr :QuickRun<CR>
let g:quickrun_config={'*': {'split': ''}}
let g:quickrun_config.cpp = {
            \   'command': 'g++',
            \   'cmdopt': '-std=c++11'
            \ }

" colorscheme molokai
colorscheme inkpot
