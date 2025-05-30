{
  description = "Framework 13 AMD NixOS Configuration with Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Pin Hyprland to a stable version that works with current nixpkgs
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.48.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          
          # Hyprland configuration
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
          
          # Home Manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.dylan = import ./modules/home.nix;
              extraSpecialArgs = { 
                inherit hyprland;
              };
            };
          }
        ];
      };
    };
  };
}