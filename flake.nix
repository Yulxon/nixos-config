{
  description = "chumi's nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    rime-ice = {
      url = "github:iDvel/rime-ice";
      flake = false;
    };
    codex-nix = {
      url = "github:SecBear/codex-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      flake = { inherit inputs; };
      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit flake; };
          modules = [
            host
            ./modules
            home-manager.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit flake; };
                users.chumi.imports = [ ./home ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        asus = mkHost ./hosts/asus;
        redmi = mkHost ./hosts/redmi;
      };
    };
}
