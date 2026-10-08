{
  config,
  pkgs,
  host,
  ...
}:
let
  dotfiles = "${host.homeDirectory}/dotfiles";
  link = relative: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${relative}";
in
{
  imports = [ ./packages.nix ];

  home = {
    inherit (host) username homeDirectory;
    stateVersion = "26.05";
    sessionPath = [
      "${dotfiles}/bin"
      "${host.homeDirectory}/bin"
    ];
    sessionVariables = {
      DOTFILE_CONFIG = "${dotfiles}/config";
      ZELLIJ_CONFIG_DIR = "${dotfiles}/config/zellij";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      MIGEMO_DICT = "${pkgs.cmigemo}/share/migemo/utf-8/migemo-dict";
    };
    file = {
      ".gitconfig".source = link "gitconfig";
      ".tigrc".source = link "tigrc";
    };
  };

  # Keep editable settings outside the read-only Nix store, including lazy-lock.json.
  xdg.configFile = {
    "nvim".source = link "config/nvim";
    "wezterm/wezterm.lua".source = link "config/wezterm/wezterm.lua";
    "alacritty/alacritty.toml".source = link "config/alacritty/alacritty.toml";
    "zellij".source = link "config/zellij";
    "starship.toml".source = link "config/starship.toml";
    "pypoetry/config.toml".source = link "config/pypoetry/config.toml";
    "git/ignore".source = link "config/git/ignore";
    "bashmarks/bashmarks.sh".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/huyng/bashmarks/deb1a63194c592c519c84e63d8756fe1867bc7aa/bashmarks.sh";
      hash = "sha256-fdswJOHMcoFOE0CtaZkKnLR1GTgVpW9z4JXN3dD+h7Q=";
    };
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    initExtra = ''
      export DOTFILES_HOME_MANAGER=1
      . "${dotfiles}/bashrc"
      . "${config.xdg.configHome}/bashmarks/bashmarks.sh"
    '';
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    withPython3 = true;
    withNodeJs = true;
    # Load HM's generated setup through the wrapper, leaving our init.lua intact.
    sideloadInitLua = true;
    extraWrapperArgs = [
      "--set"
      "MIGEMO_DICT"
      "${pkgs.cmigemo}/share/migemo/utf-8/migemo-dict"
    ];
  };
}
