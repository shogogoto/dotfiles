" coc-explorer' s setting
"
" https://github.com/weirongxu/coc-explorer
let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'tab:$': {
\     'position': 'tab:$',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\   'home': {
\     'root-uri': '~',
\  },
\   'setting': {
\     'root-uri': '~/dotfiles/settings.vim',
\  },
\ }

" Use preset argument to open it
nmap <space>xv <Cmd>CocCommand explorer --preset .vim<CR>
nmap <space>xf <Cmd>CocCommand explorer --preset floating<CR>
nmap <space>xc <Cmd>CocCommand explorer --preset cocConfig<CR>
nmap <space>xb <Cmd>CocCommand explorer --preset buffer<CR>
nmap <space>xh <Cmd>CocCommand explorer --preset home<CR>
nmap <space>xv <Cmd>CocCommand explorer --preset setting<CR>

" List all presets
nmap <space>xl <Cmd>CocList explPresets<CR>



