# modules/home.nix
{ config, pkgs, lib, hyprland, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # HYPRLAND CONFIGURATION with 1.6x scaling
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    
    extraConfig = ''
      # Monitor configuration with 1.6x scaling
      monitor=eDP-1,preferred,auto,1.6

      # Input configuration
      input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
        touchpad {
          natural_scroll = true
          disable_while_typing = true
          scroll_factor = 0.3
        }
      }

      # General appearance for 1.6x scaling
      general {
        gaps_in = 8
        gaps_out = 16
        border_size = 3
        col.active_border = rgba(bd93f9ff) rgba(ff79c6ff) 45deg
        col.inactive_border = rgba(44475aff)
        layout = dwindle
      }

      # Decoration settings for 1.6x scaling
      decoration {
        rounding = 12
        blur {
          enabled = true
          size = 4
          passes = 2
        }
      }

      # Animation settings
      animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      # Layout settings
      dwindle {
        pseudotile = true
        preserve_split = true
      }

      # Autostart applications
      exec-once = waybar
      exec-once = hyprpaper
      exec-once = swaync
      exec-once = nm-applet --indicator
      exec-once = blueman-applet
      exec-once = hyprctl setcursor Nordzy-cursors 40
      exec-once = cliphist daemon

      # Key bindings
      bind = SUPER, Return, exec, kitty
      bind = SUPER, Q, killactive
      bind = SUPER, M, exit
      bind = SUPER, E, exec, thunar
      bind = SUPER, V, togglefloating
      bind = SUPER, D, exec, env GDK_SCALE=1.6 wofi --show drun
      bind = SUPER, F, fullscreen
      bind = SUPER, B, exec, firefox
      bind = SUPER, L, exec, swaylock
      
      # Super key alone opens wofi with proper scaling
      bindr = SUPER, Super_L, exec, env GDK_SCALE=1.6 wofi --show drun

      # Move focus
      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d

      # Switch workspaces
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5

      # Move active window to workspace
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5

      # Mouse bindings
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Volume control
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

      # Brightness control - Framework 13 F7/F8
      bind = , F7, exec, brightnessctl set 5%-
      bind = , F8, exec, brightnessctl set 5%+
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
      bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+

      # Power button
      bind = , XF86PowerOff, exec, wlogout
      
      # Clipboard history
      bind = SUPER, C, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

      # Environment variables for 1.6x scaling
      env = XCURSOR_THEME,Nordzy-cursors
      env = XCURSOR_SIZE,40
      env = WLR_NO_HARDWARE_CURSORS,1
      env = GDK_SCALE,1.6
      env = GDK_DPI_SCALE,0.625
      env = MOZ_ENABLE_WAYLAND,1
    '';
  };
  
  # TERMINAL CONFIGURATION for 1.6x scaling (updated for newer home-manager)
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    settings = {
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 15;  # Adjusted for 1.6x scaling
      enable_audio_bell = false;
      window_padding_width = 12;  # Adjusted for 1.6x scaling
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
    };
  };

  # VS CODE CONFIGURATION for 1.6x scaling (updated for newer home-manager)
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        vscodevim.vim
        yzhang.markdown-all-in-one
        bbenoist.nix
        ms-vscode.hexeditor
        ms-python.python
      ];
      userSettings = {
        "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace'";
        "editor.fontSize" = 16;  # Adjusted for 1.6x scaling
        "editor.fontLigatures" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.minimap.enabled" = false;
        "workbench.colorTheme" = "Dracula";
        "window.zoomLevel" = 0.5;  # Adjusted for 1.6x scaling
        "files.autoSave" = "afterDelay";
        "telemetry.telemetryLevel" = "off";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "workbench.list.smoothScrolling" = true;
        "editor.smoothScrolling" = true;
      };
    };
  };

  # Firefox with improved scaling (33% bigger than current)
programs.firefox = {
  enable = true;
  profiles.default = {
    name = "Default";
    settings = {
      # Performance settings
      "gfx.webrender.all" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.ffvpx.enabled" = false;
      
      # Privacy settings
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "dom.security.https_only_mode" = true;
      
      # UI scaling - Increased by 33% from previous 1.072
      "layout.css.devPixelsPerPx" = "1.426";  # 1.072 * 1.33 = 1.426
      "browser.uidensity" = 0;  # Changed from 1 (compact) to 0 (normal) for larger UI elements
      
      # Force UI scaling for Firefox
      "widget.gtk.overlay-scrollbars.enabled" = false;
      "browser.display.use_system_colors" = false;
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "ui.textScaleFactor" = 143;  # Increased from 107 to 143 (33% bigger)
      
      # Better aesthetics
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.tabs.loadInBackground" = true;
      "browser.urlbar.suggest.bookmark" = true;
      "browser.urlbar.suggest.history" = true;
      "browser.urlbar.suggest.openpage" = true;
      
      # Additional scaling improvements
      "browser.chrome.site_icons" = true;
      "browser.chrome.favicons" = true;
      "security.dialog_enable_delay" = 0;
      
      # Ensure proper DPI awareness
      "layout.css.dpi" = 154;  # 96 * 1.6 (your system scaling)
      "browser.zoom.full" = true;  # Enable full page zoom instead of text-only
    };
  };
};

   # Modern Wofi configuration with icons and Dracula theme
  home.file.".config/wofi/config".text = ''
    # Modern Wofi Configuration for Framework 13 with 1.6x scaling
    # Window dimensions - larger for better icon display
    width=700
    height=500

    # Layout settings
    show=drun
    mode=drun
    allow_images=true
    image_size=48
    columns=2
    orientation=vertical

    # Positioning
    location=center
    halign=fill
    valign=center

    # Font and text
    font=JetBrains Mono 14
    prompt=Search Applications...

    # Behavior
    filter_rate=100
    allow_markup=true
    no_actions=true
    show_all=false
    print_command=true
    layer=overlay
    insensitive=true
    matching=fuzzy

    # Performance and caching
    cache_file=/home/dylan/.cache/wofi-drun
    gtk_dark=true
    dpi_aware=true

    # Enable proper icon support
    normal_window=false
    term=kitty

    # Key bindings
    key_expand=Tab
    key_exit=Escape
  '';

  # Modern wofi style with glassmorphism and Dracula colors
  home.file.".config/wofi/style.css".text = ''
    /* Modern Wofi Style with Dracula Colors and Icons */
    * {
        font-family: "JetBrains Mono", "Font Awesome 6 Free", monospace;
        font-weight: 500;
    }

    /* Main window with glassmorphism effect */
    window {
        margin: 0px;
        border-radius: 20px;
        background: linear-gradient(135deg, 
            rgba(40, 42, 54, 0.95) 0%, 
            rgba(68, 71, 90, 0.9) 100%);
        border: 2px solid rgba(189, 147, 249, 0.3);
        backdrop-filter: blur(10px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        animation: fadeIn 0.2s ease-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: scale(0.95);
        }
        to {
            opacity: 1;
            transform: scale(1);
        }
    }

    /* Search input styling */
    #input {
        margin: 15px 20px 10px 20px;
        border: 2px solid rgba(98, 114, 164, 0.4);
        background: rgba(68, 71, 90, 0.6);
        color: #f8f8f2;
        border-radius: 15px;
        font-size: 16px;
        padding: 15px 20px;
        transition: all 0.3s ease;
        backdrop-filter: blur(5px);
        box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    #input:focus {
        border-color: rgba(189, 147, 249, 0.8);
        background: rgba(68, 71, 90, 0.8);
        box-shadow: 
            inset 0 2px 4px rgba(0, 0, 0, 0.2),
            0 0 20px rgba(189, 147, 249, 0.3);
    }

    #input::placeholder {
        color: rgba(248, 248, 242, 0.5);
    }

    /* Container styling */
    #inner-box {
        margin: 10px 20px 20px 20px;
        background: transparent;
        border-radius: 15px;
    }

    #outer-box {
        margin: 0px;
        padding: 0px;
        background: transparent;
    }

    /* Scrollable area */
    #scroll {
        margin: 0px;
        border: none;
        background: transparent;
        padding: 5px;
    }

    /* Individual application entries */
    #entry {
        background: rgba(68, 71, 90, 0.3);
        margin: 4px 8px;
        padding: 15px 20px;
        border-radius: 12px;
        border: 1px solid rgba(98, 114, 164, 0.2);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        backdrop-filter: blur(5px);
        display: flex;
        align-items: center;
        min-height: 60px;
    }

    #entry:hover {
        background: rgba(98, 114, 164, 0.4);
        border-color: rgba(189, 147, 249, 0.6);
        transform: translateY(-2px);
        box-shadow: 
            0 8px 25px rgba(0, 0, 0, 0.3),
            0 0 20px rgba(189, 147, 249, 0.2);
    }

    #entry:selected {
        background: linear-gradient(135deg, 
            rgba(189, 147, 249, 0.3) 0%, 
            rgba(255, 121, 198, 0.2) 100%);
        border-color: rgba(189, 147, 249, 0.8);
        transform: translateY(-2px);
        box-shadow: 
            0 8px 25px rgba(0, 0, 0, 0.4),
            0 0 25px rgba(189, 147, 249, 0.4);
    }

    /* Icon styling */
    #entry #img {
        margin-right: 15px;
        border-radius: 8px;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    }

    #entry:hover #img {
        transform: scale(1.05);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    }

    #entry:selected #img {
        transform: scale(1.1);
        box-shadow: 0 6px 16px rgba(189, 147, 249, 0.4);
    }

    /* Text styling */
    #text {
        color: #f8f8f2;
        font-size: 15px;
        font-weight: 500;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
        flex: 1;
        margin: 0;
        padding: 0;
    }

    #entry:hover #text {
        color: #ffffff;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
    }

    #entry:selected #text {
        color: #ffffff;
        font-weight: 600;
        text-shadow: 
            0 1px 3px rgba(0, 0, 0, 0.4),
            0 0 10px rgba(189, 147, 249, 0.3);
    }

    /* Scrollbar styling */
    #scroll scrollbar {
        background: transparent;
        border: none;
        border-radius: 10px;
        margin: 0;
        padding: 0;
    }

    #scroll scrollbar slider {
        background: rgba(189, 147, 249, 0.4);
        border: none;
        border-radius: 10px;
        transition: all 0.3s ease;
    }

    #scroll scrollbar slider:hover {
        background: rgba(189, 147, 249, 0.6);
    }

    #scroll scrollbar trough {
        background: rgba(68, 71, 90, 0.3);
        border-radius: 10px;
        margin: 5px;
    }

    /* Loading state */
    window.loading {
        opacity: 0.8;
    }

    /* Responsive adjustments for smaller screens */
    @media (max-width: 800px) {
        window {
            border-radius: 15px;
        }
        
        #input {
            margin: 10px 15px 8px 15px;
            padding: 12px 16px;
            font-size: 14px;
        }
        
        #inner-box {
            margin: 8px 15px 15px 15px;
        }
        
        #entry {
            padding: 12px 16px;
            min-height: 50px;
        }
        
        #entry #img {
            margin-right: 12px;
        }
        
        #text {
            font-size: 14px;
        }
    }

    /* Dark mode enhancements */
    @media (prefers-color-scheme: dark) {
        window {
            background: linear-gradient(135deg, 
                rgba(40, 42, 54, 0.98) 0%, 
                rgba(68, 71, 90, 0.95) 100%);
            border-color: rgba(189, 147, 249, 0.4);
        }
        
        #input {
            background: rgba(68, 71, 90, 0.8);
            border-color: rgba(98, 114, 164, 0.5);
        }
        
        #entry {
            background: rgba(68, 71, 90, 0.4);
            border-color: rgba(98, 114, 164, 0.3);
        }
    }
  '';
  
# WAYBAR CONFIGURATION scaled down by 25% from 1.6x scaling
programs.waybar = {
  enable = true;
  
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 34;  # Reduced from 45 (45 * 0.75 = 33.75, rounded to 34)
      spacing = 0;
      margin-top = 5;  # Reduced from 6 (6 * 0.75 = 4.5, rounded to 5)
      margin-left = 9;  # Reduced from 12 (12 * 0.75 = 9)
      margin-right = 9;  # Reduced from 12 (12 * 0.75 = 9)
      
      modules-left = [
        "custom/launcher"
        "hyprland/workspaces" 
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "tray"
        "custom/power"
      ];

      # Module configurations (unchanged - these don't affect visual size)
      "custom/launcher" = {
        format = " ";
        on-click = "wofi --show drun";
        tooltip = false;
      };

      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
      };

      clock = {
        timezone = "America/New_York";
        format = "{:%a %d %b  %I:%M %p}";
        format-alt = "{:%A, %B %d, %Y (%R)}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      pulseaudio = {
        scroll-step = 5;
        format = "{icon} {volume}%";
        format-muted = "󰖁 Muted";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip = true;
        tooltip-format = "Volume: {volume}%";
      };

      network = {
        interface = "wlp*";
        format = "{ifname}";
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰖪 Disconnected";
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-wifi = "{essid} ({signalStrength}%) 󰤨";
        tooltip-format-ethernet = "{ifname} 󰈀";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
        on-click = "nm-connection-editor";
      };

      cpu = {
        interval = 2;
        format = "󰍛 {usage}%";
        max-length = 10;
        on-click = "kitty --class btop -e btop";
      };

      memory = {
        interval = 2;
        format = "󰾆 {percentage}%";
        tooltip = true;
        tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G";
        on-click = "kitty --class btop -e btop";
      };

      battery = {
        # Auto-detect battery (works better than specifying BAT0)
        # bat = "BAT0";
        # adapter = "ADP1";
        interval = 10;
  states = {
    warning = 30;
    critical = 15;
  };
  max-length = 25;
  format = "{icon} {capacity}%";
  format-warning = "󰂃 {capacity}%";
  format-critical = "󰁺 {capacity}%";
  format-charging = "󰂄 {capacity}%";
  format-plugged = "󰂄 {capacity}%";
  format-alt = "{icon} {time} ({capacity}%)";
  format-full = "󰁹 {capacity}%";
  format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
  tooltip = true;
  tooltip-format = "{timeTo}, {capacity}%\n{power}W\nLeft: Power Menu | Right: Toggle Mode | Scroll: Quick Switch";
  
  # Click actions for TLP power management
  on-click = "power-menu-battery";                    # Left click: Open power menu
  on-click-right = "tlp-toggle-mode";                # Right click: Toggle AC/Battery mode
  on-click-middle = "kitty --class power-stats -e sudo tlp-stat -s"; # Middle click: Quick stats
  
  # Scroll to quickly change power profiles
  on-scroll-up = "sudo tlp ac && notify-send 'TLP' 'AC Profile (Performance)'";
  on-scroll-down = "sudo tlp bat && notify-send 'TLP' 'Battery Profile (Power Saving)'";
  
  format-not-charging = "󰂄 {capacity}%";
};

      tray = {
        icon-size = 12;  # Reduced from 16 (16 * 0.75 = 12)
        spacing = 5;     # Reduced from 6 (6 * 0.75 = 4.5, rounded to 5)
        show-passive-items = true;
      };

      "custom/power" = {
        format = "⏻";
        tooltip = false;
        on-click = "wlogout";
        on-click-right = "systemctl poweroff";
      };
    };
  };

  # CSS styling scaled down by 25%
  style = ''
    * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono Nerd Font", "Font Awesome 6 Free", monospace;
        font-size: 11px;  /* Reduced from 14px (14 * 0.75 = 10.5, rounded to 11) */
        min-height: 0;
        margin: 0;
        padding: 0;
    }

    window#waybar {
        background: transparent;
        color: #f8f8f2;
    }

    tooltip {
        background: rgba(40, 42, 54, 0.95);
        border: 1px solid #6272a4;
        border-radius: 8px;  /* Reduced from 10px (10 * 0.75 = 7.5, rounded to 8) */
        color: #f8f8f2;
        font-size: 10px;  /* Reduced from 13px (13 * 0.75 = 9.75, rounded to 10) */
    }

    .modules-left,
    .modules-center,
    .modules-right {
        background: rgba(40, 42, 54, 0.85);
        border-radius: 14px;  /* Reduced from 18px (18 * 0.75 = 13.5, rounded to 14) */
        margin: 0 5px;  /* Reduced from 6px (6 * 0.75 = 4.5, rounded to 5) */
        padding: 0 5px;  /* Reduced from 6px (6 * 0.75 = 4.5, rounded to 5) */
        border: 2px solid rgba(68, 71, 90, 0.5);
    }

    .modules-left > widget:first-child > #workspaces,
    .modules-center > widget > #clock,
    .modules-right > widget > * {
        margin: 0 3px;  /* Reduced from 4px (4 * 0.75 = 3) */
        padding: 5px 9px;  /* Reduced from 6px 12px (6*0.75=4.5→5, 12*0.75=9) */
        border-radius: 9px;  /* Reduced from 12px (12 * 0.75 = 9) */
        background: transparent;
        transition: all 0.3s ease;
    }

    #custom-launcher {
        color: #50fa7b;
        font-size: 14px;  /* Reduced from 18px (18 * 0.75 = 13.5, rounded to 14) */
        font-weight: bold;
        margin-right: 5px;  /* Reduced from 6px (6 * 0.75 = 4.5, rounded to 5) */
        padding: 5px 11px;  /* Reduced from 6px 15px (6*0.75=4.5→5, 15*0.75=11.25→11) */
    }

    #custom-launcher:hover {
        background: rgba(80, 250, 123, 0.1);
        color: #50fa7b;
    }

    #workspaces {
        padding: 0;
        margin: 0;
        background: transparent;
    }

    #workspaces button {
        padding: 5px 9px;  /* Reduced from 6px 12px (6*0.75=4.5→5, 12*0.75=9) */
        margin: 0 2px;  /* Reduced from 2px (2 * 0.75 = 1.5, rounded to 2) */
        background: transparent;
        color: #6272a4;
        border-radius: 8px;  /* Reduced from 10px (10 * 0.75 = 7.5, rounded to 8) */
        transition: all 0.3s ease;
        font-size: 11px;  /* Reduced from 15px (15 * 0.75 = 11.25, rounded to 11) */
        min-width: 24px;  /* Reduced from 32px (32 * 0.75 = 24) */
    }

    #workspaces button:hover {
        background: rgba(98, 114, 164, 0.2);
        color: #f8f8f2;
    }

    #workspaces button.active {
        background: rgba(189, 147, 249, 0.3);
        color: #bd93f9;
        font-weight: bold;
    }

    #clock {
        color: #f8f8f2;
        font-weight: 500;
        font-size: 11px;  /* Reduced from 15px (15 * 0.75 = 11.25, rounded to 11) */
        padding: 5px 12px;  /* Reduced from 6px 16px (6*0.75=4.5→5, 16*0.75=12) */
    }

    #clock:hover {
        background: rgba(248, 248, 242, 0.1);
    }

    #pulseaudio {
        color: #ff79c6;
    }

    #pulseaudio:hover {
        background: rgba(255, 121, 198, 0.1);
    }

    #pulseaudio.muted {
        color: #6272a4;
    }

    #network {
        color: #50fa7b;
    }

    #network:hover {
        background: rgba(80, 250, 123, 0.1);
    }

    #network.disconnected {
        color: #ff5555;
    }

    #cpu {
        color: #ffb86c;
    }

    #cpu:hover {
        background: rgba(255, 184, 108, 0.1);
    }

    #memory {
        color: #ff79c6;
    }

    #memory:hover {
        background: rgba(255, 121, 198, 0.1);
    }

    #battery {
        color: #50fa7b;
    }

    #battery:hover {
        background: rgba(80, 250, 123, 0.1);
    }

    #battery.charging {
        color: #f1fa8c;
    }

    #battery.warning:not(.charging) {
        color: #ffb86c;
    }

    #battery.critical:not(.charging) {
        color: #ff5555;
    }

    #tray {
        background: transparent;
    }

    #tray > .passive {
        opacity: 0.5;
    }

    #custom-power {
        color: #ff5555;
        font-size: 14px;  /* Reduced from 18px (18 * 0.75 = 13.5, rounded to 14) */
        font-weight: bold;
        margin-left: 5px;  /* Reduced from 6px (6 * 0.75 = 4.5, rounded to 5) */
        padding: 5px 11px;  /* Reduced from 6px 15px (6*0.75=4.5→5, 15*0.75=11.25→11) */
    }

    #custom-power:hover {
        background: rgba(255, 85, 85, 0.2);
        color: #ff5555;
    }
  '';
};

  # GTK configuration for 1.6x scaling
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Inter";
      size = 13;  # Adjusted for 1.6x scaling
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 40;  # Updated for 1.6x scaling
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 40;  # Updated for 1.6x scaling
    };
  };
}