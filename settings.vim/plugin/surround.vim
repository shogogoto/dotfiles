Plug 'tpope/vim-surround'               " コマンド: ds s, cs w1 w2 /*change surround*/, ys motion s, S w ::  https://qiita.com/takuyanin/items/5eb009e737a235e51ab2
Plug 'cohama/lexima.vim'                " 自動で対となる文字を補完 e.g. 括弧閉じる
Plug 'junegunn/rainbow_parentheses.vim' " 括弧の対ごとに色分け

" Activation based on file type
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END
let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
