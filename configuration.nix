{ config, pkgs, lib, ... }:

let
  minesddm = pkgs.fetchFromGitHub {
    owner = "Davi-S";
    repo = "sddm-theme-minesddm";
    rev = "main";
    sha256 = "sha256-X64m9fs+a6M0cgJKCNsk2kQU43DEcwEvD/1nQ755BGE=";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
    <nixos-hardware/framework/13-inch/7040-amd>
      ./hardware-configuration.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;
  programs.hyprland.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Set your time zone.
  time.timeZone = "America/New_York";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = false;
  
  # SDDM Configuration with minesddm theme
  services.displayManager.sddm = {
    enable = true;
    theme = "minesddm";
    settings = {
      Theme = {
        CursorTheme = "Nordzy-cursors";
        CursorSize = "32";
        ThemeDir = "${minesddm}";
      };
    };
  };

# Configure power button behavior
services.logind = {
  extraConfig = ''
    HandlePowerKey=ignore
    HandlePowerKeyLongPress=poweroff
  '';
};

# Add ACPI event handling
services.acpid = {
  enable = true;
  handlers = {
    power-button = {
      event = "button/power.*";
      action = "${pkgs.writeShellScript "power-button-action" ''
        /run/current-system/sw/bin/power-menu
      ''}";
    };
  };
};
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # Enable Power-Profiles-Daemon
  services.power-profiles-daemon.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.dylan = {
    isNormalUser = true;
    description = "dylan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
  # Install firefox.
  programs.firefox.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
nixpkgs.overlays = [
  (final: prev: {
    gnome = prev.gnome // {
      adwaita-icon-theme = prev.gnome.adwaita-icon-theme.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          # Fix cursor sizes for HiDPI displays
          for size in 24 32 48 64 96; do
            cd $out/share/icons/Adwaita/''${size}x''${size}/cursors
            for cursor in *; do
              if [ -f "$cursor" ]; then
                echo "Fixing cursor size for $cursor (''${size}px)"
                ${prev.xcursorgen}/bin/xcursorgen -size ''${size} "$cursor" "$cursor.new"
                mv "$cursor.new" "$cursor"
              fi
            done
          done
        '';
      });
    };
  })
];

# Font configuration
  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal emulators
    kitty
    ghostty
    # Development tools
    git
    vscode
    vim
    neovim
    lf
    figlet
    # Network management
    networkmanagerapplet  # System tray applet
    libnotify  # For notifications
    networkmanager
    rofi
    # Applications
    firefox
    cider  # Music player
    steam
    # Hyprland-related
    wofi  # App launcher
    waybar  # Status bar
    swaynotificationcenter  # For notifications
    hyprpaper  # Wallpaper
    # Utils
    wget
    curl
    htop
    btop
    ripgrep
    blueman  # Bluetooth manager
    power-profiles-daemon
    poweralertd  # Battery notifications
    light
    swaylock-effects
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg
    busybox
    xfce.thunar
    wireplumber
    fzf
    speedtest-cli
    cointop
    micro
    slack-term
    thefuck
    lolcat
    tuir
    bibata-cursors
    kew
    xdotool # for window automation
    nodejs_20
    nodePackages.npm
    code-cursor
    
    
    # SDDM Theme - You can keep this for the sugar-dark theme as backup
    (pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v1.2";
      sha256 = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
    })

    adwaita-icon-theme  # Contains the basic cursor theme
    hyprlock
    hypridle
    brightnessctl
    # Clipboard support
    wl-clipboard
    
    # Screenshot tools
    grim
    slurp
    
    # Session management
    wlogout
    
    # Authentication dialogs
    libsForQt5.polkit-kde-agent
    
    # Additional utilities
    swaybg  # For solid color backgrounds
    imagemagick  # For image manipulation
    neofetch
    pipes
   
    # Power button script
  (pkgs.writeShellScriptBin "power-menu" ''
    wlogout
  '')

  ];
  # Cursor theme and size
  environment.variables = {
    XCURSOR_THEME = "Nordzy-cursors";
    XCURSOR_SIZE = "32";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
  # Make cursor configuration consistent
  environment.etc."gtk-2.0/gtkrc".text = ''
    gtk-cursor-theme-name="Nordzy-cursors"
    gtk-cursor-theme-size=32
  '';
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Nordzy-cursors
    gtk-cursor-theme-size=32
  '';
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Nordzy-cursors
    gtk-cursor-theme-size=32
  '';
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
