# Complete enhanced configuration.nix for Framework 13 AMD with Hyprland optimizations
# Fixed syntax errors and proper Nix escaping
{ config, pkgs, lib, ... }:

let
  # SDDM theme
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

  # ===== BOOT CONFIGURATION =====
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Framework 13 AMD specific kernel parameters for optimal performance
    kernelParams = [
      "amd_pstate=active"
      "nvme.noacpi=1"
      "acpi_osi=Linux"
      "acpi_backlight=native"
      # Performance optimizations
      "mitigations=off"
      "processor.max_cstate=1"
    ];
    
    kernelModules = [ "kvm-amd" ];
    
    # AMD GPU optimizations
    extraModprobeConfig = ''
      options amdgpu deep_color=1
      options amdgpu dc=1
      options amdgpu hwmon=1
      options amdgpu gpu_recovery=1
      options amdgpu noretry=0
    '';

    # Kernel sysctl optimizations for responsiveness
    kernel.sysctl = {
      # Network performance
      "net.core.default_qdisc" = "cake";
      "net.ipv4.tcp_congestion_control" = "bbr";
      
      # Memory management for SSD
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      
      # Responsiveness optimizations
      "kernel.sched_autogroup_enabled" = 0;
      "kernel.sched_child_runs_first" = 0;
    };
  };

  # ===== NETWORKING =====
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # Performance optimization
    networkmanager.wifi.powersave = false;
  };

  # ===== NIX SETTINGS =====
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 10485760;
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
      
      # Performance optimizations
      keep-outputs = true;
      keep-derivations = true;
      
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    
    # Garbage collection optimization
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    
    optimise.automatic = true;
  };

  # ===== LOCALE AND TIME =====
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # ===== DISPLAY AND DESKTOP ENVIRONMENT =====
  services.xserver.enable = true;
  
  # Hyprland with official plugins
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # Enable official plugins from nixpkgs
    plugins = [
      pkgs.hyprlandPlugins.hyprspace      # Workspace overview
      pkgs.hyprlandPlugins.hyprwinwrap    # Window wrapping for btop wallpaper
    ];
  };

  # Enable MATE
  services.xserver.desktopManager.mate.enable = true;

  # Disable other desktop environments
  services.xserver.desktopManager.plasma6.enable = false;
  
  # SDDM display manager with custom theme
  services.displayManager.sddm = {
    enable = true;
    theme = "minesddm";
    settings = {
      Theme = {
        CursorTheme = "Nordzy-cursors";
        CursorSize = "32";
        ThemeDir = "${minesddm}";
      };
      General = {
        GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=1.6,QT_FONT_DPI=154";
      };
    };
  };

  # ===== INPUT CONFIGURATION =====
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enhanced touchpad configuration with gesture support
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = false;
      naturalScrolling = true;
      disableWhileTyping = true;
      clickMethod = "clickfinger";
      accelSpeed = "0.3";
      # Enable advanced gesture support
      additionalOptions = ''
        Option "TappingDrag" "false"
        Option "TappingDragLock" "false" 
        Option "ClickMethod" "clickfinger"
        Option "PalmDetection" "on"
        Option "PalmMinWidth" "8"
        Option "PalmMinZ" "100"
        Option "CoastingSpeed" "20"
        Option "CoastingFriction" "50"
        Option "PressureMotionMinZ" "30"
        Option "PressureMotionMaxZ" "160"
        Option "PressureMotionMinFactor" "1"
        Option "PressureMotionMaxFactor" "1"
        Option "GrabEventDevice" "false"
      '';
    };
  };

  # ===== POWER MANAGEMENT =====
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
    extraConfig = ''
      HandlePowerKey=ignore
      HandlePowerKeyLongPress=poweroff
      IdleAction=suspend
      IdleActionSec=600
      RuntimeDirectorySize=2G
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
  
  # TLP power management for Framework 13
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      
      # Platform profiles
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      
      # Battery charge thresholds for longevity
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 90;
      
      # USB/PCI power management
      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_PHONE = 1;
      
      # Runtime power management
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
      
      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };
  
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;

  # ===== PRINTING =====
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.hplip ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  
  # ===== AUDIO =====
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Performance optimizations
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };

  # ===== BLUETOOTH =====
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = true;
        ReconnectAttempts = 7;
        ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
      };
    };
  };
  
  # ===== GRAPHICS =====
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr
      rocmPackages.rocm-runtime
      mesa  # Updated from mesa.drivers
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
    ];
  };

  # ===== SECURITY =====
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
  };

  # ===== SYSTEM MAINTENANCE =====
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "weekly";
    flake = "/etc/nixos";
  };

  services.flatpak.enable = true;
  services.fstrim.enable = true;

  # ===== USER CONFIGURATION =====
  users.users.dylan = {
    isNormalUser = true;
    description = "dylan";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "video" 
      "audio" 
      "input"
      "render"
      "disk"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  
  # ===== ENVIRONMENT VARIABLES =====
  environment.variables = {
    # Wayland optimizations
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    
    # HiDPI settings for 1.6x scaling
    GDK_SCALE = "1.6"; 
    GDK_DPI_SCALE = "0.625";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.6";
    QT_FONT_DPI = "154";
    QT_QPA_PLATFORM = "wayland;xcb";
    
    # Cursor configuration
    XCURSOR_THEME = "macOS-BigSur";
    XCURSOR_SIZE = "24";
    
    # Performance optimizations
    WINIT_X11_SCALE_FACTOR = "1.6";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.6";
    
    # Wayland-specific
    SDL_VIDEODRIVER = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    
    # Hardware acceleration
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };

  # ===== GTK CURSOR CONFIGURATION =====
  environment.etc = {
      "gtk-2.0/gtkrc".text = ''
      gtk-cursor-theme-name="macOS-BigSur"
      gtk-cursor-theme-size=24
    '';
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=macOS-BigSur
      gtk-cursor-theme-size=24
    '';
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-cursor-theme-name=macOS-BigSur
      gtk-cursor-theme-size=24
    '';
    "modprobe.d/amdgpu.conf".text = ''
      options amdgpu deep_color=1
      options amdgpu dc=1
      options amdgpu gpu_recovery=1
      options amdgpu mes=1
      options amdgpu noretry=0
    '';
  };

  # ===== FONTS =====
  fonts = {
    packages = with pkgs; [
      # Core fonts
      font-awesome
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      
      # Additional fonts
      inter
      roboto
      ubuntu_font_family
      
      # Nerd fonts - updated syntax for new nerd-fonts structure
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Liberation Serif" "Noto Serif" ];
        sansSerif = [ "Inter" "Liberation Sans" "Noto Sans" ];
        monospace = [ "JetBrains Mono" "Liberation Mono" "Noto Sans Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
  
  # ===== SYSTEM PACKAGES =====
  environment.systemPackages = with pkgs; [
    # ===== TERMINAL EMULATORS =====
    kitty
    ghostty
    
    # ===== DEVELOPMENT TOOLS =====
    git
    gh
    vscode
    vim
    neovim
    lf
    figlet
    tree
    
    # ===== NETWORK MANAGEMENT =====
    networkmanagerapplet
    libnotify
    networkmanager
    
    # ===== APPLICATION LAUNCHERS =====
    rofi
    
    # ===== APPLICATIONS =====
    firefox
    cider
    steam
    gimp3-with-plugins
    
    # ===== HYPRLAND ECOSYSTEM =====
    wofi
    waybar
    swaynotificationcenter
    hyprpaper
    swaylock-effects
    wlogout
    grim
    slurp
    wl-clipboard
    cliphist
    
    # Add hyprwinwrap to system packages for PATH access
    pkgs.hyprlandPlugins.hyprwinwrap
    
    # ===== SYSTEM UTILITIES =====
    wget
    curl
    htop
    btop
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    bc
    
    # ===== HARDWARE TOOLS =====
    blueman
    poweralertd
    brightnessctl
    light
    upower
    acpi
    lm_sensors
    powertop
    
    # ===== FILE MANAGEMENT =====
    xfce.thunar
    gnome-disk-utility
    
    # ===== MULTIMEDIA =====
    vlc
    pavucontrol
    wireplumber
    geeqie
    
    # ===== PRODUCTIVITY =====
    libreoffice
    nextcloud-client
    keepassxc
    syncthing
    font-manager
    
    # ===== COMMUNICATION =====
    discord
    element-desktop
    
    # ===== DEVELOPMENT =====
    nodejs_20
    nodePackages.npm
    code-cursor
    
    # ===== GESTURE SUPPORT =====
    libinput-gestures
    wmctrl
    xdotool
    
    # ===== ADDITIONAL UTILITIES =====
    speedtest-cli
    cointop
    micro
    slack-term
    thefuck
    lolcat
    tuir
    imagemagick
    fastfetch
    pipes
    busybox
    
    # ===== CURSORS AND THEMES =====
    apple-cursor
    bibata-cursors
    gnome-themes-extra
    papirus-icon-theme
    
    # Optional MATE applications
    mate.caja              # File manager
    mate.mate-terminal     # Terminal  
    mate.mate-calc         # Calculator
    mate.pluma             # Text editor

    # ===== AUTHENTICATION =====
    libsForQt5.polkit-kde-agent
    
    # ===== WALLPAPER AND BACKGROUNDS =====
    swaybg
    
    # ===== CUSTOM SCRIPTS =====
    # Auto-start btop wallpaper script - simplified approach
    (writeShellScriptBin "btop-wallpaper-autostart" ''
      #!/bin/bash
      # Auto-start btop wallpaper - simplified approach
      
      # Wait for Hyprland to fully load
      sleep 5
      
      # Kill any existing btop wallpaper instances
      ${pkgs.procps}/bin/pkill -f ".*btop.*wallpaper" 2>/dev/null || true
      
      # Wait for cleanup
      sleep 2
      
      # Launch btop in floating terminal - let window rules handle wallpaper behavior
      ${pkgs.hyprland}/bin/hyprctl dispatch exec "${pkgs.kitty}/bin/kitty --class btop-wallpaper -o font_size=11 -o background_opacity=0.8 -e ${pkgs.btop}/bin/btop"
      
      # Verify it started
      sleep 3
      if ${pkgs.procps}/bin/pgrep -f "kitty.*btop-wallpaper" >/dev/null; then
        ${pkgs.libnotify}/bin/notify-send "Btop Monitor" "Started successfully" --timeout=3000
        
        # Apply wallpaper-like positioning
        ${pkgs.hyprland}/bin/hyprctl dispatch movewindowpixel "exact 50 50,class:btop-wallpaper"
        ${pkgs.hyprland}/bin/hyprctl dispatch resizewindowpixel "exact 700 500,class:btop-wallpaper"
      else
        ${pkgs.libnotify}/bin/notify-send "Btop Monitor" "Failed to start" --urgency=critical
      fi
    '')
    
    # Performance monitoring script
    (writeShellScriptBin "hypr-performance" ''
      #!/bin/bash
      # Hyprland performance monitor for Framework 13
      
      echo "=== Hyprland Performance Monitor ==="
      echo "Framework 13 AMD - $(${pkgs.coreutils}/bin/date)"
      echo ""
      
      # System info
      echo "System Information:"
      echo "Kernel: $(${pkgs.coreutils}/bin/uname -r)"
      echo "CPU: $(${pkgs.util-linux}/bin/lscpu | ${pkgs.gnugrep}/bin/grep 'Model name' | ${pkgs.coreutils}/bin/cut -d: -f2 | ${pkgs.findutils}/bin/xargs)"
      echo "Memory: $(${pkgs.procps}/bin/free -h | ${pkgs.gawk}/bin/awk '/^Mem:/ {print $2}')"
      echo ""
      
      # Hyprland info
      echo "Hyprland Status:"
      if ${pkgs.procps}/bin/pgrep -x Hyprland >/dev/null; then
        echo "✅ Hyprland is running"
      else
        echo "❌ Hyprland is not running"
      fi
      echo ""
      
      # Plugin status
      echo "Plugin Status:"
      if command -v hyprctl >/dev/null 2>&1; then
        ${pkgs.hyprland}/bin/hyprctl plugin list | ${pkgs.gnugrep}/bin/grep -E "(hyprspace|hyprwinwrap)" || echo "No plugins loaded"
      else
        echo "hyprctl not available"
      fi
      echo ""
      
      # Performance metrics
      echo "Performance Metrics:"
      load_avg=$(${pkgs.coreutils}/bin/uptime | ${pkgs.gawk}/bin/awk -F'load average:' '{print $2}' | ${pkgs.gawk}/bin/awk '{print $1}' | ${pkgs.gnused}/bin/sed 's/,//')
      echo "Load average: $load_avg"
      
      mem_usage=$(${pkgs.procps}/bin/free | ${pkgs.gnugrep}/bin/grep Mem | ${pkgs.gawk}/bin/awk '{printf "%.0f", $3/$2 * 100.0}')
      echo "Memory usage: ''${mem_usage}%"
      
      # Temperature
      if command -v sensors >/dev/null 2>&1; then
        cpu_temp=$(${pkgs.lm_sensors}/bin/sensors 2>/dev/null | ${pkgs.gnugrep}/bin/grep -E 'Tctl|CPU' | ${pkgs.gawk}/bin/awk '{print $2}' | ${pkgs.coreutils}/bin/head -1 || echo 'N/A')
        echo "CPU temperature: $cpu_temp"
      fi
      echo ""
      
      # Recommendations
      echo "Performance Analysis:"
      if (( $(echo "$load_avg > 2.0" | ${pkgs.bc}/bin/bc -l 2>/dev/null || echo 0) )); then
        echo "⚠️  High system load detected: $load_avg"
      else
        echo "✅ System load normal: $load_avg"
      fi
      
      if [ "$mem_usage" -gt 80 ]; then
        echo "⚠️  High memory usage: ''${mem_usage}%"
      else
        echo "✅ Memory usage normal: ''${mem_usage}%"
      fi
    '')
    
    # Gesture debug script
    (writeShellScriptBin "gesture-debug" ''
      #!/bin/bash
      # Debug libinput gestures for Framework 13 touchpad
      
      echo "=== Framework 13 Gesture Debugger ==="
      echo "This will monitor touchpad gestures. Press Ctrl+C to stop."
      echo ""
      
      # Check libinput-gestures status
      if ${pkgs.procps}/bin/pgrep -x "libinput-gestures" >/dev/null; then
        echo "✅ libinput-gestures is running"
      else
        echo "❌ libinput-gestures is not running"
        echo "Start with: libinput-gestures-setup start"
      fi
      echo ""
      
      # Check user groups
      echo "User permissions:"
      if ${pkgs.coreutils}/bin/groups | ${pkgs.gnugrep}/bin/grep -q input; then
        echo "✅ User is in input group"
      else
        echo "❌ User not in input group. Run: sudo usermod -a -G input $USER"
      fi
      echo ""
      
      # Show gesture config
      echo "Gesture configuration:"
      if [ -f ~/.config/libinput-gestures.conf ]; then
        echo "Config file exists:"
        ${pkgs.gnugrep}/bin/grep -E "^gesture:" ~/.config/libinput-gestures.conf | ${pkgs.coreutils}/bin/head -5
      else
        echo "❌ No gesture configuration found at ~/.config/libinput-gestures.conf"
      fi
      echo ""
      
      # Monitor events
      echo "Monitoring touchpad events (perform gestures to see output):"
      if [ "$EUID" -eq 0 ]; then
        ${pkgs.libinput}/bin/libinput debug-events | ${pkgs.gnugrep}/bin/grep -E "(GESTURE|POINTER_MOTION)" --line-buffered
      else
        echo "Note: Some events may require sudo access"
        ${pkgs.libinput}/bin/libinput debug-events 2>/dev/null | ${pkgs.gnugrep}/bin/grep -E "(GESTURE|POINTER)" --line-buffered || {
          echo "Cannot access input events. Try running with sudo or check permissions."
        }
      fi
    '')
    
    # Power management scripts
    (writeShellScriptBin "power-menu-battery" ''
      #!/bin/bash
      choice=$(echo -e "󰂄 Battery Status\n⚡ AC Profile\n🔋 Battery Profile\n⚙️ TLP Settings\n📊 Power Statistics\n🔧 Advanced TLP Config" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Power Management")
      
      case "$choice" in
        "󰂄 Battery Status")
          ${pkgs.kitty}/bin/kitty --class floating-terminal -e ${pkgs.bash}/bin/bash -c "
            echo '=== Battery Information ==='
            ${pkgs.upower}/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0
            echo
            echo '=== TLP Status ==='
            sudo ${pkgs.tlp}/bin/tlp-stat -b
            read -p 'Press Enter to close...'
          "
          ;;
        "⚡ AC Profile")
          sudo ${pkgs.tlp}/bin/tlp ac && ${pkgs.libnotify}/bin/notify-send "TLP" "Switched to AC profile (Performance mode)"
          ;;
        "🔋 Battery Profile") 
          sudo ${pkgs.tlp}/bin/tlp bat && ${pkgs.libnotify}/bin/notify-send "TLP" "Switched to Battery profile (Power saving mode)"
          ;;
        "⚙️ TLP Settings")
          ${pkgs.kitty}/bin/kitty --class floating-terminal -e ${pkgs.bash}/bin/bash -c "
            echo '=== Current TLP Configuration ==='
            sudo ${pkgs.tlp}/bin/tlp-stat -c
            echo
            read -p 'Press Enter to close...'
          "
          ;;
        "📊 Power Statistics")
          ${pkgs.kitty}/bin/kitty --class floating-terminal -e ${pkgs.bash}/bin/bash -c "
            echo '=== Power Statistics ==='
            sudo ${pkgs.tlp}/bin/tlp-stat -s
            echo
            echo '=== Temperature Sensors ==='
            ${pkgs.lm_sensors}/bin/sensors
            echo
            read -p 'Press Enter to close...'
          "
          ;;
        "🔧 Advanced TLP Config")
          ''${EDITOR:-${pkgs.nano}/bin/nano} /etc/tlp.conf
          ;;
      esac
    '')

    (writeShellScriptBin "tlp-toggle-mode" ''
      #!/bin/bash
      if ${pkgs.acpi}/bin/acpi -a | ${pkgs.gnugrep}/bin/grep -q "on-line"; then
        sudo ${pkgs.tlp}/bin/tlp bat
        ${pkgs.libnotify}/bin/notify-send "TLP" "Forced Battery Profile (Power Saving)" -i battery-caution
      else
        sudo ${pkgs.tlp}/bin/tlp ac  
        ${pkgs.libnotify}/bin/notify-send "TLP" "Forced AC Profile (Performance)" -i battery-full-charging
      fi
    '')
    
    # Waybar utility scripts
    (writeShellScriptBin "waybar-weather" ''
      #!/bin/bash
      location="New+York"
      weather=$(${pkgs.curl}/bin/curl -s "https://wttr.in/$location?format=1" 2>/dev/null | ${pkgs.coreutils}/bin/head -c -1)
      if [ -z "$weather" ]; then
        echo "󰼢 N/A"
      else
        echo "$weather"
      fi
    '')
    
    (writeShellScriptBin "waybar-system" ''
      #!/bin/bash
      case "$1" in
        "cpu")
          echo "CPU: $(${pkgs.coreutils}/bin/nproc) cores"
          echo "Load: $(${pkgs.coreutils}/bin/uptime | ${pkgs.gawk}/bin/awk -F'load average:' '{print $2}')"
          ;;
        "memory")
          ${pkgs.procps}/bin/free -h | ${pkgs.gawk}/bin/awk '/^Mem/ {printf "Used: %s/%s (%.1f%%)", $3, $2, $3/$2*100}'
          ;;
        *)
          echo "Usage: waybar-system [cpu|memory]"
          ;;
      esac
    '')
    
    # Power menu script
    (writeShellScriptBin "power-menu" ''
      ${pkgs.wlogout}/bin/wlogout
    '')
    
    # Wofi performance benchmark script
    (writeShellScriptBin "wofi-benchmark" ''
      #!/bin/bash
      echo "=== Wofi Performance Benchmark ==="
      
      # Clear cache for clean test
      ${pkgs.coreutils}/bin/rm -f ~/.cache/wofi-*
      
      echo "Benchmarking Wofi startup time (5 runs)..."
      total_time=0
      for i in {1..5}; do
        start_time=$(${pkgs.coreutils}/bin/date +%s.%N)
        ${pkgs.coreutils}/bin/timeout 2 ${pkgs.wofi}/bin/wofi --show drun &
        WOFI_PID=$!
        sleep 0.5
        ${pkgs.util-linux}/bin/kill $WOFI_PID 2>/dev/null
        end_time=$(${pkgs.coreutils}/bin/date +%s.%N)
        
        run_time=$(echo "$end_time - $start_time" | ${pkgs.bc}/bin/bc)
        echo "Run $i: ''${run_time}s"
        total_time=$(echo "$total_time + $run_time" | ${pkgs.bc}/bin/bc)
        
        sleep 0.2
      done
      
      avg_time=$(echo "scale=3; $total_time / 5" | ${pkgs.bc}/bin/bc)
      echo "Average startup time: ''${avg_time}s"
      
      if (( $(echo "$avg_time > 0.3" | ${pkgs.bc}/bin/bc -l) )); then
        echo "⚠️  Wofi startup is slow. Try optimizations in config."
      else
        echo "✅ Wofi performance is good!"
      fi
    '')
    
    # Hyprspace theme switcher
    (writeShellScriptBin "hyprspace-theme" ''
      #!/bin/bash
      case "$1" in
        "dracula")
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_bg_color "rgba(40, 42, 54, 0.85)"
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_border_color "rgba(189, 147, 249, 1)"
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_border_inactive_color "rgba(68, 71, 90, 1)"
          ${pkgs.libnotify}/bin/notify-send "Hyprspace" "Switched to Dracula theme"
          ;;
        "catppuccin")
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_bg_color "rgba(30, 30, 46, 0.8)"
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_border_color "rgba(137, 180, 250, 1)"
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_border_inactive_color "rgba(88, 91, 112, 1)"
          ${pkgs.libnotify}/bin/notify-send "Hyprspace" "Switched to Catppuccin theme"
          ;;
        "nord")
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_bg_color "rgba(46, 52, 64, 0.8)"
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_border_color "rgba(136, 192, 208, 1)"
          ${pkgs.hyprland}/bin/hyprctl keyword plugin:hyprspace:overview_border_inactive_color "rgba(76, 86, 106, 1)"
          ${pkgs.libnotify}/bin/notify-send "Hyprspace" "Switched to Nord theme"
          ;;
        *)
          echo "Usage: hyprspace-theme [dracula|catppuccin|nord]"
          ;;
      esac
    '')
  ];

  # ===== XDG PORTAL CONFIGURATION =====
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # ===== SYSTEMD SERVICES =====
  systemd.services = {
    # Optimize journal for SSD
    "systemd-journald" = {
      serviceConfig = {
        SystemMaxUse = "100M";
        RuntimeMaxUse = "50M";
      };
    };
  };

  # ===== SYSTEM STATE VERSION =====
  system.stateVersion = "24.11";
}