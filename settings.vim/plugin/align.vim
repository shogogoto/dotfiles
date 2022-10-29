Plug 'ntpeters/vim-better-whitespace'  " 行末の半角スペースを可視化　:FixWhitespaceで削除
Plug 'junegunn/vim-easy-align'          " 指定文字で整形:gaモーション  https://qiita.com/takuyanin/items/846cb2b3e541f79f0d54

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0
nnoremap ]w :NextTrailingWhitespace<CR>
nnoremap [w :PrevTrailingWhitespace<CR>

"" vim-easy-align 指定文字で揃うよう整形
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
