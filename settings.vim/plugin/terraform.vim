" https://www.mukeshsharma.dev/2022/02/08/neovim-workflow-for-terraform.html
Plug 'hashivim/vim-terraform' "enable syntax hilight
Plug 'prabirshrestha/vim-lsp' " depend from mattn's setting
Plug 'mattn/vim-lsp-settings' " terraform-lsの設定が書いてあると聞いて

let g:LanguageClient_serverCommands = {
    \ 'terraform': ['terraform-ls', 'serve'],
    \ }
" https://github.com/hashicorp/terraform-ls/blob/main/docs/USAGE.md
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
