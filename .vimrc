"画面表示の設定
set nowrap         "    ウィンドウの幅より長い行は折り返され、次の行に続けて表示
set wildmenu
set list
set listchars=tab:>.,trail:_,extends:>,precedes:<,nbsp:%
set number         " 行番号を表示する
set cursorline     " カーソル行の背景色を変える
"set cursorcolumn   " カーソル位置のカラムの背景色を変える
set laststatus=2   " ステータス行を常に表示
set cmdheight=2    " メッセージ表示欄を2行確保
set showmatch      " 対応する括弧を強調表示
set helpheight=999 " ヘルプを画面いっぱいに開く

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set scrolloff=8                " 上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set ruler                      "カーソルが何行目の何列目に置かれているかを表示する

" ファイル処理関連の設定
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     "保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread   "外部でファイルに変更がされた場合は読みなおす
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない

" 検索/置換の設定
set smartcase     "検索パターンに大文字が含まれている場合は区別して検索する
set hlsearch   " 検索文字列をハイライトする
set incsearch  " インクリメンタルサーチを行う
set ignorecase " 大文字と小文字を区別しない
set smartcase  "大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan   " 最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault   " 置換の時 g オプションをデフォルトで有効にする

" タブ/インデントの設定
set expandtab     " タブ入力を複数の空白入力に置き換える
set tabstop=4     " 画面上でタブ文字が占める幅
set shiftwidth=4  " 自動インデントでずれる幅
set softtabstop=4 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smarttab

" 動作環境との統合関連の設定
set clipboard=unnamed,unnamedplus  " OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
"set mouse=a                        " マウスの入力を受け付ける
set shellslash                     " Windows でもパスの区切り文字を / にする

" コマンドラインの設定
set wildmenu wildmode=list:longest,full " コマンドラインモードでTABキーによるファイル名補完を有効にする
set history=10000                       " コマンド履歴を10000件保存する

" ビープの設定
set visualbell t_vb= "ビープ音すべてを無効にする
set noerrorbells     "エラーメッセージの表示時にビープを鳴らさない




" ref: https://qiita.com/ulwlu/items/98901f4c4f0683e7aa57
" setting
filetype plugin indent on
syntax on

if has("vim_starting")
    set nocompatible
endif


if !filereadable(expand('~/.vim/autoload/plug.vim'))
    if !executable("curl")
        echoerr "You have to install curl or first install vim-plug yourself!"
        execute "q!"
    endif
    echo "Installing Vim-Plug..."
    echo ""
    silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let g:not_finish_vimplug = "yes"
    autocmd VimEnter * PlugInstall
endif


" plugin
call plug#begin(expand('~/.vim/plugged'))
Plug 'mattn/vim-starwars'
"" space + ne -> sidebar
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
"" ga -> align
Plug 'junegunn/vim-easy-align'
"" space + qr -> exec script
Plug 'thinca/vim-quickrun'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'tpope/vim-commentary' " gcc -> comment
Plug 'tomtom/tcomment_vim'
"" option bar ステータスバーイイ感じ"
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"" auto bracket
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround' "オートでクォートなど囲う
"Plug 'jiangmiao/auto-pairs'

"" auto format
Plug 'Chiel92/vim-autoformat'
Plug 'nathanaelkane/vim-indent-guides'
"" error detect
"Plug 'scrooloose/syntastic'
Plug 'dense-analysis/ale' "syntasitcより高性能なリンターチェック
"" delete white space
Plug 'bronson/vim-trailing-whitespace'
"" auto complete
Plug 'sheerun/vim-polyglot' "様々な言語のシンタックスやインデントを提供
Plug 'Valloric/YouCompleteMe'
Plug 'ervandew/supertab'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

"" html
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'
"" javascript
Plug 'jelera/vim-javascript-syntax'
"" php
Plug 'arnaud-lb/vim-php-namespace'
"" python
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
"" space + sh -> vimshell
Plug 'Shougo/vimshell.vim'
"" snippet
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'airblade/vim-gitgutter' "Gitの変更行を表示

Plug 'tomasr/molokai'
Plug 'Shougo/unite.vim'       "最近使ったファイルを表示できる
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'Shougo/ddc.vim'
"Plug 'vim-denops/denops.vim'
" DenoでVimプラグインを開発するためのプラグイン
"Plug 'vim-denops/denops.vim'
"vimのバージョンを8.2にしたら怒られたからコメントアウト
" ポップアップウィンドウを表示するプラグイン
"Plug 'Shougo/pum.vim'
" カーソル周辺の既出単語を補完するsource
"Plug 'Shougo/ddc-around'
" ファイル名を補完するsource
"Plug 'LumaKernel/ddc-file'
" 入力中の単語を補完の対象にするfilter
"Plug 'Shougo/ddc-matcher_head'
" 補完候補を適切にソートするfilter
"Plug 'Shougo/ddc-sorter_rank'
" 補完候補の重複を防ぐためのfilter
"Plug 'Shougo/ddc-converter_remove_overlap'


call plug#end()
let mapleader="\<Space>"

" ultisnip
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"

"" youcompleteme
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
let g:ycm_auto_trigger = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "?"
let g:ycm_key_list_stop_completion = ['<C-y>', '<Enter>']
let g:ycm_seed_identifiers_with_syntax = 1
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:make = 'gmake'
if exists('make')
    let g:make = 'make'
endif

"" auto-format
"au BufWrite * :Autoformat

"" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

"" emmet
autocmd FileType html imap <buffer><expr><tab>
            \ emmet#isExpandable() ? "\<plug>(emmet-expand-abbr)" :
            \ "\<tab>"

" nerdtree
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1  "起動時にNERDTreeを表示"
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 30
let NERDTreeShowHidden=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <Leader>dir :NERDTreeTabsToggle<CR> "表示コマンド
autocmd BufWritePre * :FixWhitespace
augroup NERD
    au!
    "autocmd VimEnter * NERDTree
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

"" syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='?'
let g:syntastic_warning_symbol='?'
let g:syntastic_style_error_symbol = '?'
let g:syntastic_style_warning_symbol = '?'
let g:syntastic_auto_loc_list=1
let g:syntastic_aggregate_errors = 1
"" jedi-vim
let g:jedi#popup_on_dot = 0
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "0"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3
"autocmd FileType python setlocal completeopt-=preview

let g:syntastic_python_checkers=['python3', 'flake8']
"let g:polyglot_disabled = ['python']
let python_highlight_all = 1


"" vim-airline
let g:airline#extensions#virtualenv#enabled = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
if !exists('g:airline_powerline_fonts')
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline_left_sep          = '?'
    let g:airline_left_alt_sep      = '≫'
    let g:airline_right_sep         = '?'
    let g:airline_right_alt_sep     = '≪'
    let g:airline#extensions#branch#prefix     = '?' "?, ?, ?
    let g:airline#extensions#readonly#symbol   = '?'
    let g:airline#extensions#linecolumn#prefix = '¶'
    let g:airline#extensions#paste#symbol      = 'ρ'
    let g:airline_symbols.linenr    = '?'
    let g:airline_symbols.branch    = '?'
    let g:airline_symbols.paste     = 'ρ'
    let g:airline_symbols.paste     = 'T'
    let g:airline_symbols.paste     = '∥'
    let g:airline_symbols.whitespace = 'Ξ'
else
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
endif

" function
"" xaml
augroup MyXML
    autocmd!
    autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
    autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
    autocmd!
    autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
    autocmd!
    autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END
if !exists('*s:setupWrapping')
    function s:setupWrapping()
        set wrap
        set wm=2
        set textwidth=79
    endfunction
endif

"" make/cmake
augroup vimrc-make-cmake
    autocmd!
    autocmd FileType make setlocal noexpandtab
    autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"" python
augroup vimrc-python
    autocmd!
    autocmd FileType python setlocal
                \ formatoptions+=croq softtabstop=4
                \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" shortcut leader=Space
"" save
" nnoremap <Leader>w :w<CR>
" nnoremap <Leader>qqq :q!<CR>
" nnoremap <Leader>eee :e<CR>
" nnoremap <Leader>wq :wq<CR>
" nnoremap <Leader>nn :noh<CR>

"" split
nnoremap <Leader>s :<C-u>split<CR>
nnoremap <Leader>v :<C-u>vsplit<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <Leader>t :tabnew<CR>

"" ignore wrap
"nnoremap j gj
"nnoremap k gk
"nnoremap <Down> gj
"nnoremap <Up> gk

"" Sft + y => yunk to EOL
nnoremap Y y$

"" + => increment
nnoremap + <C-a>

"" - => decrement
nnoremap - <C-x>

"" move 15 words
"nmap <silent> <Tab> 15<Right>
"nmap <silent> <S-Tab> 15<Left>
"nmap <silent> ll 15<Right>
"nmap <silent> hh 15<Left>
"nmap <silent> jj 15<Down>
"nmap <silent> kk 15<Up>

"" pbcopy for OSX copy/paste
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>

" move line/word
"nmap <C-e> $
"nmap <C-a> 0
"nmap <C-f> W
"nmap <C-b> B
"imap <C-e> <C-o>$
"imap <C-a> <C-o>0
"imap <C-f> <C-o>W
"imap <C-b> <C-o>B

" base
"set encoding=utf-8
"set fileencoding=utf-8
"set fileencodings=utf-8
"set bomb
"set binary
"set ttyfast
"set backspace=indent,eol,start
"set splitright
"set splitbelow
"set hidden
"set hlsearch
"set incsearch
"set ignorecase
"set smartcase
"set nobackup
"set noswapfile
"set fileformats=unix,dos,mac
"set gcr=a:blinkon0
"set scrolloff=3
"set laststatus=2
"set modeline
"set modelines=10
"set title
"set titleold="Terminal"
"set titlestring=%F
"set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\
"set autoread
"set noerrorbells visualbell t_vb=
"set whichwrap=b,s,h,l,<,>,[,]

" template
"augroup templateGroup
"    autocmd!
"    autocmd BufNewFile *.html :0r ~/vim-template/t.html
"    autocmd BufNewFile *.cpp :0r ~/vim-template/t.cpp
"    autocmd BufNewFile *.py :0r ~/vim-template/t.py
"augroup END
" snippet
"let g:UltiSnipsSnippetDirectories=["~/vim-snippets/"]


"######################################################################
" plugin for Markdown
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" この下に追加したいプラグインを入力する
Plugin 'VundleVim/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'kannokanno/previm'
Plugin 'tyru/open-browser.vim'
Plugin 'leafgarland/typescript-vim'
call vundle#end()

" plasticboy/vim-markdown
" 折りたたみの禁止
"let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_auto_insert_bullets = 0
"let g:vim_markdown_new_list_item_indent = 0

" kannokanno/previm
autocmd BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a Google\ Chrome'
" ctrl pでプレビュー
nnoremap <silent> <C-p> :PrevimOpen<CR>

" tyru/open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"#####################################################################

let g:indent_guides_enable_on_vim_startup = 1

let g:unite_enable_start_insert=1
" ファイル一覧
noremap <C-P> :Unite buffer<CR>
" 最近使ったファイルの一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" sourcesを「今開いているファイルのディレクトリ」とする
noremap <C-Z> :Unite file_mru<CR>
noremap :uff :<C-u>UniteWithBufferDir file -buffer-name=file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>]



" 補完 https://note.com/yasukotelin/n/na87dc604e042
" 最初の一件目を選択状態 & Enterで確定 + 選んでいるときはまだ挿入したくない
" 補完表示時のEnterで改行をしない
"inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
"set completeopt=menuone,noinsert
"inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
"inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"


"call ddc#custom#patch_global('sources', ['around'])
"call ddc#custom#patch_global('sourceOptions', {
"            \ '_': {
"                \   'matchers': ['matcher_head'],
"                \   'sorters': ['sorter_rank']},
"                \ })
"call ddc#custom#patch_global('sourceOptions', {
"            \ 'around': {'mark': 'A'},
"            \ })
"call ddc#custom#patch_global('sourceParams', {
"            \ 'around': {'maxSize': 500},
"            \ })
"
"call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
"call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
"            \ 'clangd': {'mark': 'C'},
"            \ })
"call ddc#custom#patch_filetype('markdown', 'sourceParams', {
"            \ 'around': {'maxSize': 100},
"            \ })
"
"" <TAB>: completion.
"inoremap <silent><expr> <TAB>
"            \ ddc#map#pum_visible() ? '<C-n>' :
"            \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
"            \ '<TAB>' : ddc#map#manual_complete()
"
"" <S-TAB>: completion back.
"inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'
"
"call ddc#enable()
"
"let g:molokai_original = 1
"let g:rehash256 = 1




colorscheme molokai
