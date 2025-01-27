Plug 'tpope/vim-surround'               " コマンド: ds s, cs w1 w2 /*change surround*/, ys motion s, S w ::  https://qiita.com/takuyanin/items/5eb009e737a235e51ab2
Plug 'cohama/lexima.vim'                " 自動で対となる文字を補完 e.g. 括弧閉じる
Plug 'junegunn/rainbow_parentheses.vim' " 括弧の対ごとに色分け
" memo https://qiita.com/takuyanin/items/5eb009e737a235e51ab2
" d s [e] :delete surround
" c s [e] :change surround
" y s [mo] [d] : you surround
" S [d]  :when visual mode

autocmd BufRead *.* :RainbowParentheses

let g:rainbow#max_level = 16
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
