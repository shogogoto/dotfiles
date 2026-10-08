{
  description = "Linux user environment and dotfiles managed by Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      host = import ./nix/host.nix;
      pkgs = import nixpkgs {
        inherit (host) system;
        config.allowUnfree = true;
      };
      home = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit host; };
        modules = [ ./nix/home.nix ];
      };
    in
    {
      homeConfigurations.gotoh = home;
      packages.${host.system} = {
        home-manager = home-manager.packages.${host.system}.home-manager;
        default = home.activationPackage;
      };
      checks.${host.system}.home = home.activationPackage;
      formatter.${host.system} = pkgs.nixfmt;
    };
}
