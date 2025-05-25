# Complete configuration.nix for Framework 13 AMD
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
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Framework-specific kernel parameters
  boot.kernelParams = [
    "amd_pstate=active"
    "nvme.noacpi=1"
    "acpi_osi=Linux"
    "acpi_backlight=native"
  ];
  
  boot.kernelModules = [ "kvm-amd" ];
  
  boot.extraModprobeConfig = ''
    options amdgpu deep_color=1
    options amdgpu dc=1
    options amdgpu hwmon=1
  '';

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 10485760;
    max-jobs = "auto";
    cores = 0;
    auto-optimise-store = true;
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Time and locale
  time.timeZone = "America/New_York";
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

  # Display and desktop
  services.xserver.enable = true;
  
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.desktopManager.plasma6.enable = false;
  
  # SDDM
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

  # Power management
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandlePowerKey=ignore
      HandlePowerKeyLongPress=poweroff
      IdleAction=suspend
      IdleActionSec=300
    '';
  };

  services.acpid = {
    enable = true;
    handlers = {
      power-button = {
        event = "button/power.*";
        action = "${pkgs.writeShellScript "power-button-action" ''
          ${pkgs.wlogout}/bin/wlogout
        ''}";
      };
    };
  };
  
  # Input configuration
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = false;
      naturalScrolling = true;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
      accelSpeed = "0.3";
    };
  };
  
  # TLP power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };
  
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  
  # Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  
  # Graphics (updated for newer NixOS)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr
    ];
  };
  
  # Maintenance
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "weekly";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;
  
  services.flatpak.enable = true;

  # User account
  users.users.dylan = {
    isNormalUser = true;
    description = "dylan";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  
  # Environment variables (updated to 1.666667 scaling)
  environment.variables = {
    # Wayland
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    
    # HiDPI settings for 1.666667x scaling (167%)
    GDK_SCALE = "1.666667"; 
    GDK_DPI_SCALE = "0.6";  # Adjusted for 1.666667
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.666667";
    QT_FONT_DPI = "160";  # 96 * 1.666667
    
    # Cursor - larger for higher scaling
    XCURSOR_THEME = "Nordzy-cursors";
    XCURSOR_SIZE = "48";  # Increased from 32 for 1.666667
    
    # Force scaling for problematic apps
    WINIT_X11_SCALE_FACTOR = "1.666667";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.666667";
  };

  # GTK cursor configuration (updated for 1.666667 scaling)
  environment.etc."gtk-2.0/gtkrc".text = ''
    gtk-cursor-theme-name="Nordzy-cursors"
    gtk-cursor-theme-size=48
  '';
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Nordzy-cursors
    gtk-cursor-theme-size=48
  '';
  environment.etc."xdg/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Nordzy-cursors
    gtk-cursor-theme-size=48
  '';

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  
  # System packages
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
    networkmanagerapplet
    libnotify
    networkmanager
    
    # Application launchers
    rofi
    
    # Applications
    firefox
    cider
    steam
    
    # Hyprland-related
    wofi
    waybar
    swaynotificationcenter
    hyprpaper
    
    # Utils
    wget
    curl
    htop
    btop
    ripgrep
    blueman
    poweralertd
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
    xdotool
    nodejs_20
    nodePackages.npm
    code-cursor
    
    # Power management
    powertop
    
    # System tools
    gnome-disk-utility
    libinput-gestures
    
    # Productivity
    libreoffice
    nextcloud-client
    
    # Communication
    discord
    element-desktop
    
    # Media
    vlc
    
    # Utilities
    keepassxc
    syncthing
    font-manager
    
    # Screenshot tools
    grim
    slurp
    
    # Session management
    wlogout
    
    # Authentication dialogs
    libsForQt5.polkit-kde-agent
    
    # Additional utilities
    swaybg
    imagemagick
    neofetch
    pipes
    
    # Custom scripts
    (pkgs.writeShellScriptBin "waybar-weather" ''
      #!/bin/bash
      location="New+York"
      weather=$(curl -s "https://wttr.in/$location?format=1" 2>/dev/null | head -c -1)
      if [ -z "$weather" ]; then
        echo "󰼢 N/A"
      else
        echo "$weather"
      fi
    '')
    
    (pkgs.writeShellScriptBin "waybar-system" ''
      #!/bin/bash
      case "$1" in
        "cpu")
          echo "CPU: $(nproc) cores"
          echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
          ;;
        "memory")
          free -h | awk '/^Mem/ {printf "Used: %s/%s (%.1f%%)", $3, $2, $3/$2*100}'
          ;;
        *)
          echo "Usage: waybar-system [cpu|memory]"
          ;;
      esac
    '')
    
    # Power menu script
    (pkgs.writeShellScriptBin "power-menu" ''
      ${pkgs.wlogout}/bin/wlogout
    '')
    
    # SDDM theme backup
    (pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v1.2";
      sha256 = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
    })
    
    # Additional packages for waybar
    jq
    cliphist
    brightnessctl
    
    # Scaling and theme packages
    gnome-themes-extra
    papirus-icon-theme
    nordzy-cursor-theme
  ];

  system.stateVersion = "24.11";
}