" https://dev.classmethod.jp/articles/preview-markdown-on-vim-self/
Plug 'skanehira/preview-markdown.vim'


" let g:preview_markdown_parser=mdr
let g:preview_markdown_vertical = 1

" how to use
" % vim any.md
" :PreviewMarkdown

nnoremap <Leader>md :PreviewMarkdown<CR>


":PrevimOpenコマンド
Plug 'previm/previm'
let g:previm_open_cmd = '/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
let g:previm_wsl_mode = 1
