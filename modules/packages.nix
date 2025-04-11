# modules/packages.nix
{ config, pkgs, ... }:

{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Terminal
    kitty
    ghostty

    # Core utilities
    wget
    curl
    git
    vim
    htop
    ripgrep
    fd
    bat
    exa
    fzf
    btop

    # GUI apps
    firefox
    cider
    steam

    # Editors
    cursor  # Text editor

    # Theme
    dracula-theme
    dracula-icon-theme

    # Development tools
    gcc
    gnumake
    python3
    nodejs

    # Hardware specific tools
    lm_sensors  # For temperature monitoring
    brightnessctl  # For display brightness
    acpi  # For battery info

    # Sound
    pavucontrol
    pamixer

    # Wayland tools
    grim  # Screenshot utility
    slurp  # Area selection tool
    wf-recorder  # Screen recording
  ];

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable gaming optimizations
  programs.gamemode.enable = true;
}
