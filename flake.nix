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
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            host
            ./modules
            home-manager.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
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
