# CSS styling for 1.666667x scaling
    style = ''
      * {
          border: none;
          border# modules/home.nix
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

  # HYPRLAND CONFIGURATION with 1.666667x scaling
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    
    extraConfig = ''
      # Monitor configuration with 1.666667x scaling
      monitor=eDP-1,preferred,auto,1.666667

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

      # General appearance for 1.666667x scaling
      general {
        gaps_in = 8  # Increased for higher scaling
        gaps_out = 16  # Increased for higher scaling
        border_size = 3  # Increased for higher scaling
        col.active_border = rgba(bd93f9ff) rgba(ff79c6ff) 45deg
        col.inactive_border = rgba(44475aff)
        layout = dwindle
      }

      # Decoration settings for 1.666667x scaling
      decoration {
        rounding = 15  # Increased for higher scaling
        blur {
          enabled = true
          size = 5  # Increased for higher scaling
          passes = 2  # Increased for higher scaling
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
      exec-once = hyprctl setcursor Nordzy-cursors 48
      exec-once = cliphist daemon

      # Key bindings
      bind = SUPER, Return, exec, kitty
      bind = SUPER, Q, killactive
      bind = SUPER, M, exit
      bind = SUPER, E, exec, thunar
      bind = SUPER, V, togglefloating
      bind = SUPER, D, exec, env GDK_SCALE=1.666667 wofi --show drun
      bind = SUPER, F, fullscreen
      bind = SUPER, B, exec, firefox
      bind = SUPER, L, exec, swaylock
      
      # Super key alone opens wofi with proper scaling
      bindr = SUPER, Super_L, exec, env GDK_SCALE=1.666667 wofi --show drun

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

      # Environment variables for 1.666667x scaling
      env = XCURSOR_THEME,Nordzy-cursors
      env = XCURSOR_SIZE,48
      env = WLR_NO_HARDWARE_CURSORS,1
      env = GDK_SCALE,1.666667
      env = GDK_DPI_SCALE,0.6
      env = MOZ_ENABLE_WAYLAND,1
    '';
  };
  
  # TERMINAL CONFIGURATION for 1.666667x scaling (updated for newer home-manager)
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    settings = {
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 16;  # Increased for 1.666667x scaling
      enable_audio_bell = false;
      window_padding_width = 15;  # Increased for 1.666667x scaling
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
    };
  };

  # VS CODE CONFIGURATION for 1.666667x scaling (updated for newer home-manager)
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
        "editor.fontSize" = 18;  # Increased for 1.666667x scaling
        "editor.fontLigatures" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.minimap.enabled" = false;
        "workbench.colorTheme" = "Dracula";
        "window.zoomLevel" = 0.67;  # Adjusted for 1.666667x scaling
        "files.autoSave" = "afterDelay";
        "telemetry.telemetryLevel" = "off";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "workbench.list.smoothScrolling" = true;
        "editor.smoothScrolling" = true;
      };
    };
  };

  # Firefox with better settings for 1.666667x scaling
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
        
        # UI scaling for 1.666667x - UPDATED for better scaling
        "layout.css.devPixelsPerPx" = "1.666667";
        "browser.uidensity" = 0;  # Normal density
        
        # Force UI scaling for Firefox
        "widget.gtk.overlay-scrollbars.enabled" = false;
        "browser.display.use_system_colors" = false;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "ui.textScaleFactor" = 167;  # 167% text scaling
        
        # Better aesthetics
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.loadInBackground" = true;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = true;
      };
    };
  };

  # Wofi configuration for 1.666667x scaling
  home.file.".config/wofi/config".text = ''
    width=800
    height=533
    font=JetBrains Mono 18
    orientation=vertical
    halign=center
    valign=center
    show=drun
    prompt=Applications
    filter_rate=100
    allow_markup=true
    no_actions=true
    show_all=false
    print_command=true
    layer=overlay
    insensitive=true
    cache_file=/home/dylan/.cache/wofi-drun
    gtk_dark=true
    dpi_aware=true
  '';

  # Create the wofi style with 1.666667x scaling
  home.file.".config/wofi/style.css".text = ''
    window {
        margin: 0px;
        border: 3px solid #bd93f9;
        background-color: #282a36;
        border-radius: 20px;
        font-size: 18px;
    }

    #input {
        margin: 8px;
        border: 3px solid #6272a4;
        background-color: #44475a;
        color: #f8f8f2;
        border-radius: 15px;
        font-size: 18px;
        padding: 12px;
    }

    #inner-box {
        margin: 8px;
        background-color: #282a36;
        color: #f8f8f2;
        border-radius: 15px;
    }

    #outer-box {
        margin: 8px;
        padding: 15px;
        background-color: #282a36;
        border-radius: 15px;
    }

    #scroll {
        margin: 8px;
        border: 3px solid #6272a4;
        background-color: #44475a;
        border-radius: 15px;
    }

    #text {
        margin: 8px;
        color: #f8f8f2;
        font-size: 18px;
        padding: 6px;
    }

    #entry {
        padding: 12px;
        margin: 4px;
        min-height: 48px;
    }

    #entry:selected {
        background-color: #44475a;
        border-radius: 15px;
    }

    #text:selected {
        color: #ff79c6;
        font-weight: bold;
    }
  '';
  
  # WAYBAR CONFIGURATION for 1.666667x scaling
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 50;  # Increased for 1.666667x scaling
        spacing = 0;
        margin-top = 8;
        margin-left = 15;
        margin-right = 15;
        
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

        # Module configurations
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
          bat = "BAT0";
          adapter = "ADP1";
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
          format-alt = "{icon} {time}";
          format-full = "󰁹 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          tooltip = true;
          tooltip-format = "{timeTo}, {capacity}%\n{power}W";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
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

    # CSS styling for 1.666667x scaling
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrains Mono Nerd Font", "Font Awesome 6 Free", monospace;
          font-size: 16px;  /* Increased for 1.666667x scaling */
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
          border-radius: 12px;  /* Increased for 1.666667x scaling */
          color: #f8f8f2;
          font-size: 15px;  /* Increased for 1.666667x scaling */
      }

      .modules-left,
      .modules-center,
      .modules-right {
          background: rgba(40, 42, 54, 0.85);
          border-radius: 20px;  /* Increased for 1.666667x scaling */
          margin: 0 8px;  /* Increased for 1.666667x scaling */
          padding: 0 8px;  /* Increased for 1.666667x scaling */
          border: 2px solid rgba(68, 71, 90, 0.5);  /* Increased for 1.666667x scaling */
      }

      .modules-left > widget:first-child > #workspaces,
      .modules-center > widget > #clock,
      .modules-right > widget > * {
          margin: 0 5px;  /* Increased for 1.666667x scaling */
          padding: 8px 15px;  /* Increased for 1.666667x scaling */
          border-radius: 15px;  /* Increased for 1.666667x scaling */
          background: transparent;
          transition: all 0.3s ease;
      }

      #custom-launcher {
          color: #50fa7b;
          font-size: 20px;  /* Increased for 1.666667x scaling */
          font-weight: bold;
          margin-right: 8px;  /* Increased for 1.666667x scaling */
          padding: 8px 18px;  /* Increased for 1.666667x scaling */
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
          padding: 8px 15px;  /* Increased for 1.666667x scaling */
          margin: 0 3px;  /* Increased for 1.666667x scaling */
          background: transparent;
          color: #6272a4;
          border-radius: 12px;  /* Increased for 1.666667x scaling */
          transition: all 0.3s ease;
          font-size: 17px;  /* Increased for 1.666667x scaling */
          min-width: 38px;  /* Increased for 1.666667x scaling */
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
          font-size: 17px;  /* Increased for 1.666667x scaling */
          padding: 8px 20px;  /* Increased for 1.666667x scaling */
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
          font-size: 20px;  /* Increased for 1.666667x scaling */
          font-weight: bold;
          margin-left: 8px;  /* Increased for 1.666667x scaling */
          padding: 8px 18px;  /* Increased for 1.666667x scaling */
      }

      #custom-power:hover {
          background: rgba(255, 85, 85, 0.2);
          color: #ff5555;
      }
    '';
  };

  # GTK configuration for 1.666667x scaling
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
      size = 14;  # Increased for 1.666667x scaling
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 48;  # Updated for 1.666667x scaling
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 48;  # Updated for 1.666667x scaling
    };
  };
}