{
  description = "NixOS configuration for Framework 13 AMD with Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, hyprland, hyprlock, hypridle, hyprpaper, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      # Get your hostname
      hostname = "framework";  # Change this to your preferred hostname
      username = "your-username";  # Change this to your preferred username

    in {
      nixosConfigurations.${hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit username;
          inherit hyprland hyprlock hypridle hyprpaper;
        };
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.framework-13-7040-amd

          hyprland.nixosModules.default

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit hyprland hyprlock hypridle hyprpaper;
            };
            home-manager.users.${username} = import ./modules/home.nix;
          }
        ];
      };
    };
}
