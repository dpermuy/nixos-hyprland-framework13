# modules/theme.nix
{ config, lib, pkgs, ... }:

{
  # GTK theme settings
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono";
      size = 11;
    };
  };

  # QT theme settings to match GTK
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
    };
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 24;
    gtk.enable = true;
  };

  # Download wallpaper
  home.file.".config/hypr/wallpaper.jpg".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dracula/wallpaper/master/nixos.png";
    sha256 = "0000000000000000000000000000000000000000000000000000"; # Replace with actual hash
    # You'll need to replace this with the actual SHA256 hash after downloading
    # If this fails, you can manually download a wallpaper and place it in the config
  };
}
