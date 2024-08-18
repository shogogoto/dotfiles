":PrevimOpenコマンド
Plug 'tyru/open-browser.vim'
Plug 'previm/previm'

Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" nnoremap <Leader>md :PrevimOpen<CR>
" # previm
" let g:previm_open_cmd = '/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe'
" let g:previm_open_cmd = '/mnt/c/Users/gotoa/AppData/Local/Sidekick/Application/sidekick.exe'
let g:previm_open_cmd = 'firefox'
" let g:previm_wsl_mode = 1


" # markdown-preview.nvim
nmap <Leader>md <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle
