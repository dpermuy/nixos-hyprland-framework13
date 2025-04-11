# configuration.nix
{ config, pkgs, lib, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hyprland.nix
    ./modules/packages.nix
  ];

  # Enable flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone
  time.timeZone = "America/New_York";  # Change to your timezone

  # Configure network
  networking = {
    hostName = "framework";  # Change this to match the hostname in flake.nix
    networkmanager.enable = true;
    # If using wireless, might need to explicitly enable it
    # wireless.enable = true;
  };

  # Internationalization properties
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Display manager configuration
services.displayManager = {
  defaultSession = "hyprland";
  sddm.enable = true;  # SDDM works well with Hyprland
};

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # User account
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "changeme";  # Remember to change this after first login
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = pkgs.stdenv.hostPlatform.isx86_64;  # For Steam 32-bit games
  };

  # Enable Steam hardware
  hardware.steam-hardware.enable = true;

  # Other system settings
  system.stateVersion = "23.11";  # Set to the version you're installing

  # Framework-specific optimizations
  services.thermald.enable = true;
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # For fingerprint reader if you have one
  services.fprintd.enable = true;

  # Enable CUPS for printing
  services.printing.enable = true;

  # fix SSDM config 
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;

}
