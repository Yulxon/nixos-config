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
    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ inputs.nixos-unified.flakeModules.default ];

      # Only update the inputs we actually use
      perSystem = { ... }: {
        nixos-unified.primary-inputs = [ "nixpkgs" "home-manager" ];
      };

      flake.nixosConfigurations.asus =
        self.nixos-unified.lib.mkLinuxSystem { home-manager = true; } {
          nixpkgs.hostPlatform = "x86_64-linux";
          imports = [
            ./hosts/asus
            ./modules
            {
              home-manager.users.chumi.imports = [ ./home ];
            }
          ];
        };
    };
}
