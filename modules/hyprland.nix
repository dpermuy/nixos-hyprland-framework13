# modules/hyprland.nix
{ config, lib, pkgs, hyprland, hyprlock, hypridle, hyprpaper, swaync, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  # Graphics drivers for AMD
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  # Enable XDG Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Enable polkit for privilege escalation dialogs
  security.polkit.enable = true;

  # System packages for Hyprland environment
  environment.systemPackages = with pkgs; [
    # Core utilities
    wayland
    libnotify
    wl-clipboard
    swaynotificationcenter
    wev  # Debug wayland events

    # Required services/bins by Hyprland
    xdg-desktop-portal-hyprland
    xdg-utils

    # WM helpers
    wofi
    waybar
    swaylock
    swayidle

    # Custom Hyprland packages
    hyprpaper.packages.${pkgs.system}.default
    hyprlock.packages.${pkgs.system}.default
    hypridle.packages.${pkgs.system}.default
  ];
}
