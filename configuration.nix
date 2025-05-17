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
  imports =
    [ # Include the results of the hardware scan and Framework hardware
      ./hardware-configuration.nix
    ];

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Framework-specific kernel parameters
  boot.kernelParams = [
    "amd_pstate=active"   # Better CPU frequency scaling
    "nvme.noacpi=1"       # Fix potential NVMe issues
    "acpi_osi=Linux"      # Better ACPI compatibility
    "acpi_backlight=native" # Better backlight control
  ];
  
  # Enable AMD virtualization support
  boot.kernelModules = [ "kvm-amd" ];
  
  # Extra module config for AMD GPU
  boot.extraModprobeConfig = ''
    options amdgpu deep_color=1
    options amdgpu dc=1
    options amdgpu hwmon=1
  '';

  # Networking configuration
  networking.hostName = "nixos"; # Define your hostname
  networking.networkmanager.enable = true;

  # Enable experimental Nix features (flakes and nix commands)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings = {
  # Increase download buffer
  download-buffer-size = 10485760;  # 10MB
  
  # Use more builders for parallel builds
  max-jobs = "auto";
  cores = 0;  # Use all cores
  
  # Optimize storage
  auto-optimise-store = true;
  
  # Trust substituter cache
  trusted-substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};

  # Time zone and locale settings
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

  # Enable the X11 windowing system and Wayland
  services.xserver.enable = true;
  
  # Enable Hyprland Wayland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Disable KDE Plasma
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
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandlePowerKey=ignore
      HandlePowerKeyLongPress=poweroff
      IdleAction=suspend
      IdleActionSec=300
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
  
  # Framework keyboard function keys support
  services.udev.extraRules = ''
    # Framework laptop keyboard function keys
    SUBSYSTEM=="input", ATTRS{name}=="HPDL0001:00 04F3:324B", ENV{KEYBOARD_KEY_70039}="keyboardbacklightdown"
    SUBSYSTEM=="input", ATTRS{name}=="HPDL0001:00 04F3:324B", ENV{KEYBOARD_KEY_7003a}="keyboardbacklightup"
  '';
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Touchpad configuration
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
  
  # POWER MANAGEMENT
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      
      # AMD-specific settings
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # Battery charge thresholds (customize to your preference)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };
  
  # Better temperature management for AMD
  services.thermald.enable = true;
  
  # Enable Power-Profiles-Daemon
  services.power-profiles-daemon.enable = false;
  
  # Enable CUPS for printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
  };

  # Enable network discovery of printers and services
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable bluetooth
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
  
  # Enable fingerprint reader (uncomment if you have one)
  # services.fprintd.enable = true;

  # Configure graphics drivers for AMD
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr      # This is the ROCm OpenCL runtime
    ];
  };
  
  # AUTO-UPDATES AND MAINTENANCE
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
  
  # Enable flatpak for additional applications
  services.flatpak.enable = true;

  # Define a user account
  users.users.dylan = {
    isNormalUser = true;
    description = "dylan";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "input" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  
  # Install firefox
  programs.firefox.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # HiDPI cursor overlay 
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

  # Environment variables for better HiDPI and Wayland support
  environment.variables = {
    # Wayland specific
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    
    # HiDPI settings for consistent scaling
    GDK_SCALE = "1.5"; 
    GDK_DPI_SCALE = "0.75";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.5";
    
    # Cursor configuration
    XCURSOR_THEME = "Nordzy-cursors";
    XCURSOR_SIZE = "32";
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
  
  # Font configuration
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
    swaybg  # For solid color backgrounds
    imagemagick  # For image manipulation
    neofetch
    pipes
    
    # SDDM Theme - Sugar Dark as backup
    (pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v1.2";
      sha256 = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
    })
    
    # Power button script
    (pkgs.writeShellScriptBin "power-menu" ''
      wlogout
    '')
  ];

  # Update stateVersion (keep your original value)
  system.stateVersion = "24.11";
}
