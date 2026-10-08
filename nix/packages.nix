{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Neovim, direnv, fzf and starship are installed by programs.* in home.nix.
    # Node and related tools: no mutable global npm installations.
    nodejs
    marp-cli
    npm-check-updates
    mkcert
    nssTools

    # Python is supplied by Nix; project-specific versions belong in dev shells.
    (python3.withPackages (ps: [ ps.pip ]))
    (poetry.withPlugins (ps: [
      ps.poetry-plugin-shell
      poetry.python.pkgs.poetry-dynamic-versioning
    ]))

    git
    tig
    gh
    act
    lazygit
    keychain
    openssh
    docker-client
    docker-compose
    docker-buildx
    zip
    unzip
    curl
    wget
    jq
    gnupg
    cacert
    xsel
    xclip
    wl-clipboard
    waypipe
    eog
    img2pdf
    pdftk
    fastfetch
    speedtest-cli
    ngrok
    inotify-tools
    (espanso.override {
      waylandSupport = true;
      x11Support = false;
    })

    # Neovim plugins compile parsers and Lua modules at runtime.
    gcc
    gnumake
    pkg-config
    lua5_1
    lua51Packages.luarocks
    fd
    tree-sitter
    ripgrep
    bat
    cmigemo
    silver-searcher
    universal-ctags
    zellij
    viu
  ];
}
