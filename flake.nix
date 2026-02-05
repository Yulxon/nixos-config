{
  description = "chumi's nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixos-hardware,
      nix-index-database,
      nixvim,
      catppuccin,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./host/configuration.nix
          ./modules

          nixos-hardware.nixosModules.asus-fx506hm
          # nix-index-database.nixosModules.default
          # catppuccin.nixosModules.catppuccin

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.chumi = {
              imports = [
                ./home/home.nix
                nix-index-database.homeModules.default
                catppuccin.homeModules.catppuccin
              ];
            };
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
