{
  description = "chumi's nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./host/configuration.nix
            ./programs/default.nix
          ];
        };
      };
    };
}
