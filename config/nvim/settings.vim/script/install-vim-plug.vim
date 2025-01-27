function InstallVimPlug(path) abort
  if !filereadable(expand(a:path))
    if !executable("curl")
      echoerr "You have to install curl or first install vim-plug yourself!"
      execute "q!"
    endif
    echo "Installing Vim-Plug..."
    echo ""

    let l:cmd = "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    echo json_decode(system(cmd))
    let l:result = json_decode(system(cmd))
    if result['cod'] == 200
      echo 'OK!'
    else
      echoerr result
    endif

    autocmd VimEnter * PlugInstall
  endif
endfunction
