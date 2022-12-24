" https://dev.classmethod.jp/articles/preview-markdown-on-vim-self/
Plug 'skanehira/preview-markdown.vim'

" let g:preview_markdown_parser=mdr
let g:preview_markdown_vertical = 1

" how to use
" % vim any.md
" :PreviewMarkdown

nnoremap <Leader>md :PreviewMarkdown<CR>
