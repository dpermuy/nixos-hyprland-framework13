# HYPRLAND CONFIGURATION with 1.175x scaling (UPDATED)
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    
    extraConfig = ''
      # Monitor configuration with 1.175x scaling
      monitor=eDP-1,preferred,auto,1.175

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

      # General appearance for 1.175x scaling
      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(bd93f9ff) rgba(ff79c6ff) 45deg
        col.inactive_border = rgba(44475aff)
        layout = dwindle
      }

      # Decoration settings for 1.175x scaling
      decoration {
        rounding = 10
        blur {
          enabled = true
          size = 3
          passes = 1
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
      exec-once = hyprctl setcursor Nordzy-cursors 32
      exec-once = cliphist daemon  # Clipboard history

      # Key bindings
      bind = SUPER, Return, exec, kitty
      bind = SUPER, Q, killactive
      bind = SUPER, M, exit
      bind = SUPER, E, exec, thunar
      bind = SUPER, V, togglefloating
      bind = SUPER, D, exec, wofi --show drun
      bind = SUPER, F, fullscreen
      bind = SUPER, B, exec, firefox
      bind = SUPER, L, exec, swaylock
      
      # Super key alone opens wofi
      bindr = SUPER, Super_L, exec, wofi --show drun

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

      # Environment variables for 1.175x scaling
      env = XCURSOR_THEME,Nordzy-cursors
      env = XCURSOR_SIZE,32
      env = WLR_NO_HARDWARE_CURSORS,1
      env = GDK_SCALE,1.175
      env = GDK_DPI_SCALE,0.85
      env = MOZ_ENABLE_WAYLAND,1
    '';
  };
  
  # TERMINAL CONFIGURATION for 1.175x scaling
  programs.kitty = {
    enable = true;
    theme = "Dracula";
    settings = {
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 12;  # Back to 12 for 1.175x scaling
      enable_audio_bell = false;
      window_padding_width = 10;  # Back to 10 for 1.175x scaling
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
    };
  };

  # VS CODE CONFIGURATION for 1.175x scaling
  programs.vscode = {
    enable = true;
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
      "editor.fontSize" = 13;  # Adjusted for 1.175x scaling
      "editor.fontLigatures" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Dracula";
      "window.zoomLevel" = 0.2;  # Adjusted for 1.175x scaling
      "files.autoSave" = "afterDelay";
      "telemetry.telemetryLevel" = "off";
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.list.smoothScrolling" = true;
      "editor.smoothScrolling" = true;
    };
  };

  # Firefox with better settings for 1.175x scaling
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
        
        # UI scaling for 1.175x
        "layout.css.devPixelsPerPx" = "1.175";
        "browser.uidensity" = 1;  # Compact UI
        
        # Better aesthetics
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.loadInBackground" = true;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = true;
      };
    };
  };
  
  # MODERN WAYBAR CONFIGURATION
  programs.waybar = {
    enable = true;
    
    # Use the modern waybar config from the artifact
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 0;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces" 
          "hyprland/mode"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "custom/weather"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "custom/notification"
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
          format-icons = {
            "1" = "󰈹";
            "2" = "";
            "3" = "";
            "4" = "󰭹";
            "5" = "󰝚";
            "6" = "";
            "7" = "󰒱";
            "8" = "󰕧";
            "9" = "󰊖";
            "10" = "󰽰";
          };
          on-click = "activate";
          sort-by-number = true;
        };

        "hyprland/mode" = {
          format = "<span style=\"italic\">{}</span>";
          tooltip = false;
        };

        clock = {
          timezone = "America/New_York";
          format = "{:%a %d %b  %I:%M %p}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "custom/weather" = {
          format = "{}";
          tooltip = true;
          interval = 1800;
          exec = "curl -s 'https://wttr.in/New+York?format=1' | head -c -1";
          return-type = "";
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
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
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
          tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed:0.1f}G/{swapTotal:0.1f}G";
          on-click = "kitty --class btop -e btop";
        };

        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "󰸁 {temperatureC}°C";
          format = "󰔏 {temperatureC}°C";
          tooltip = true;
          interval = 2;
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

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󰂚";
            none = "󰂛";
            dnd-notification = "󰂛";
            dnd-none = "󰂛";
            inhibited-notification = "󰂛";
            inhibited-none = "󰂛";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
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

    # Use the modern CSS style
    style = ''
      /* Import the modern waybar style from the artifact */
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrains Mono Nerd Font", "Font Awesome 6 Free", monospace;
          font-size: 13px;
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
          border-radius: 8px;
          color: #f8f8f2;
          font-size: 12px;
      }

      .modules-left,
      .modules-center,
      .modules-right {
          background: rgba(40, 42, 54, 0.85);
          border-radius: 15px;
          margin: 0 5px;
          padding: 0 5px;
          backdrop-filter: blur(20px);
          border: 1px solid rgba(68, 71, 90, 0.5);
      }

      .modules-left > widget:first-child > #workspaces,
      .modules-center > widget > #clock,
      .modules-right > widget > * {
          margin: 0 3px;
          padding: 5px 10px;
          border-radius: 10px;
          background: transparent;
          transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
      }

      #custom-launcher {
          color: #50fa7b;
          font-size: 16px;
          font-weight: bold;
          margin-right: 5px;
          padding: 5px 12px;
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
          padding: 5px 10px;
          margin: 0 2px;
          background: transparent;
          color: #6272a4;
          border-radius: 8px;
          transition: all 0.3s ease;
          font-size: 14px;
          min-width: 25px;
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

      #workspaces button.urgent {
          background: rgba(255, 85, 85, 0.3);
          color: #ff5555;
          animation: urgent 1s ease-in-out infinite alternate;
      }

      @keyframes urgent {
          to {
              background: rgba(255, 85, 85, 0.5);
          }
      }

      #clock {
          color: #f8f8f2;
          font-weight: 500;
          font-size: 14px;
          padding: 5px 15px;
      }

      #clock:hover {
          background: rgba(248, 248, 242, 0.1);
      }

      #custom-weather {
          color: #8be9fd;
          font-weight: 500;
      }

      #custom-weather:hover {
          background: rgba(139, 233, 253, 0.1);
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

      #network.wifi {
          color: #8be9fd;
      }

      #network.ethernet {
          color: #50fa7b;
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

      #temperature {
          color: #8be9fd;
      }

      #temperature:hover {
          background: rgba(139, 233, 253, 0.1);
      }

      #temperature.critical {
          color: #ff5555;
          animation: temperature-critical 1s ease-in-out infinite alternate;
      }

      @keyframes temperature-critical {
          to {
              background: rgba(255, 85, 85, 0.3);
          }
      }

      #battery {
          color: #50fa7b;
      }

      #battery:hover {
          background: rgba(80, 250, 123, 0.1);
      }

      #battery.charging {
          color: #f1fa8c;
          animation: battery-charging 2s ease-in-out infinite alternate;
      }

      @keyframes battery-charging {
          to {
              color: #50fa7b;
          }
      }

      #battery.warning:not(.charging) {
          color: #ffb86c;
      }

      #battery.critical:not(.charging) {
          color: #ff5555;
          animation: battery-critical 1s ease-in-out infinite alternate;
      }

      @keyframes battery-critical {
          to {
              background: rgba(255, 85, 85, 0.3);
          }
      }

      #custom-notification {
          color: #bd93f9;
          font-size: 16px;
      }

      #custom-notification:hover {
          background: rgba(189, 147, 249, 0.1);
      }

      #tray {
          background: transparent;
      }

      #tray > .passive {
          opacity: 0.5;
      }

      #tray > .needs-attention {
          background: rgba(255, 85, 85, 0.3);
          border-radius: 8px;
      }

      #custom-power {
          color: #ff5555;
          font-size: 16px;
          font-weight: bold;
          margin-left: 5px;
          padding: 5px 12px;
      }

      #custom-power:hover {
          background: rgba(255, 85, 85, 0.2);
          color: #ff5555;
      }

      #mode {
          background: rgba(189, 147, 249, 0.3);
          color: #bd93f9;
          border-radius: 10px;
          margin: 0 5px;
          padding: 5px 15px;
          font-weight: bold;
      }
    '';
  };

  # GTK configuration for 1.175x scaling
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
      size = 10;  # Adjusted for 1.175x scaling
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 32;  # Back to 32 for 1.175x
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 32;  # Back to 32 for 1.175x
    };
  };