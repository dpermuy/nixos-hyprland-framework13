{ config, pkgs, hyprland, ... }:

{
  # Home Manager Configuration
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # HYPRLAND CONFIGURATION
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    
    extraConfig = ''
      # Monitor configuration with proper scaling
      monitor=,preferred,auto,1.5
      
      # XWayland scaling
      xwayland {
        force_zero_scaling = true
      }
      
      # Input configuration
      input {
        kb_layout = us
        follow_mouse = 1
        sensitivity = 0
        accel_profile = flat
        
        touchpad {
          natural_scroll = true
          disable_while_typing = true
          tap-to-click = false
          clickfinger_behavior = true
        }
      }
      
      # General appearance
      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgb(bd93f9) rgb(ff79c6) 45deg
        col.inactive_border = rgb(44475a)
        layout = dwindle
      }
      
      # Decoration settings
      decoration {
        rounding = 10
        blur {
          enabled = true
          size = 3
          passes = 1
          new_optimizations = true
        }
      }
      
      # Animation settings - fine-tuned
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
        no_gaps_when_only = false
      }
      
      # Autostart applications
      exec-once = waybar
      exec-once = hyprpaper
      exec-once = swaync
      # Network management
      exec-once = nm-applet --indicator
      exec-once = blueman-applet
      # Add cursor size settings
      exec-once = hyprctl setcursor Nordzy-cursors 32
      
      # Key bindings - Mostly keeping your existing ones
      bind = SUPER, Return, exec, kitty
      bind = SUPER, Q, killactive
      bind = SUPER, M, exit
      bind = SUPER, E, exec, thunar
      bind = SUPER, V, togglefloating
      bind = SUPER, Super_L, exec, wofi --show drun
      bind = SUPER, D, exec, wofi --show drun
      bind = SUPER, P, pseudo
      bind = SUPER, F, fullscreen
      bind = SUPER, B, exec, firefox
      
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
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      
      # Move active window to workspace
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10
      
      # Mouse bindings
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      
      # Volume control
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      
      # Brightness control
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
      bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
      
      # Screenshot binding
      bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = SHIFT, Print, exec, grim - | wl-copy
      
      # Window rules
      windowrule = float, ^(pavucontrol)$
      windowrule = float, ^(blueman-manager)$
      windowrule = float, ^(nm-connection-editor)$
      windowrule = float, ^(file-roller)$
      windowrule = float, title:^(Picture-in-Picture)$
      windowrule = size 60% 60%, title:^(Picture-in-Picture)$
      windowrule = move 39% 39%, title:^(Picture-in-Picture)$
      
      # Environment variables for apps
      env = GDK_SCALE,1.5
      env = GDK_DPI_SCALE,0.75
      env = XCURSOR_SIZE,32
    '';
  };
  
  # TERMINAL CONFIGURATION
  programs.kitty = {
    enable = true;
    theme = "Dracula";
    settings = {
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 12;
      enable_audio_bell = false;
      window_padding_width = 10;
      shell = "zsh"; # If you use zsh
    };
  };
  
  # IMPROVED ZSH (uncomment if you want to use zsh)
  # programs.zsh = {
  #   enable = true;
  #   autocd = true;
  #   enableAutosuggestions = true;
  #   enableCompletion = true;
  #   syntaxHighlighting.enable = true;
  #   
  #   oh-my-zsh = {
  #     enable = true;
  #     plugins = [ "git" "sudo" "docker" "history" ];
  #     theme = "robbyrussell";
  #   };
  #   
  #   initExtra = ''
  #     # Useful aliases
  #     alias ls='ls --color=auto'
  #     alias ll='ls -la'
  #     alias rebuild='sudo nixos-rebuild switch'
  #     alias update='sudo nixos-rebuild switch --upgrade'
  #   '';
  # };
  
  # VS CODE CONFIGURATION
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      yzhang.markdown-all-in-one
      bbenoist.nix
    ];
    userSettings = {
      "editor.fontFamily" = "'JetBrains Mono', 'Droid Sans Mono', 'monospace'";
      "editor.fontSize" = 13;
      "editor.fontLigatures" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Dracula";
      "window.zoomLevel" = 0.5;
      "files.autoSave" = "afterDelay";
      "telemetry.telemetryLevel" = "off";
    };
  };
  
  # GIT CONFIGURATION
  programs.git = {
    enable = true;
    userName = "dylan";  # Change to your name
    userEmail = "dylan@permuy.me";  # Change to your email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
  
  # Firefox with privacy and productivity settings
  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";
      settings = {
        # Performance settings for responsiveness
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        
        # Better privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "dom.security.https_only_mode" = true;
        
        # Aesthetics & Usability
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.loadInBackground" = true;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = true;
      };
      userChrome = ''
        /* Dracula theme tweaks */
        :root {
          --toolbar-bgcolor: #282a36 !important;
          --tab-selected-bgcolor: #44475a !important;
          --urlbar-box-bgcolor: #44475a !important;
          --urlbar-box-hover-bgcolor: #6272a4 !important;
          --toolbar-color: #f8f8f2 !important;
        }
      '';
    };
  };
  
  # WAYBAR CONFIGURATION
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: #282a36;
        color: #f8f8f2;
      }

      #workspaces button {
        padding: 0 10px;
        background: #44475a;
        color: #f8f8f2;
        border-bottom: 3px solid transparent;
      }

      #workspaces button.active {
        background: #bd93f9;
        border-bottom: 3px solid #ff79c6;
      }

      #mode, #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #idle_inhibitor, #custom-power, #custom-launcher {
        padding: 0 10px;
        margin: 0 5px;
        background: #44475a;
        color: #f8f8f2;
        border-radius: 5px;
      }

      #battery.charging {
        background: #50fa7b;
        color: #282a36;
      }

      #battery.critical:not(.charging) {
        background: #ff5555;
        color: #f8f8f2;
        animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background: #f8f8f2;
          color: #ff5555;
        }
      }
      
      #custom-power {
        background: #ff5555;
      }
      
      #custom-launcher {
        background: #50fa7b;
        color: #282a36;
        font-size: 16px;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = ["custom/launcher" "hyprland/workspaces" "hyprland/mode"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "cpu" "memory" "network" "battery" "tray" "custom/power"];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
        };

        clock = {
          format = "{:%a, %b %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "CPU {usage}%";
          tooltip = true;
          interval = 1;
        };

        memory = {
          format = "MEM {}%";
          interval = 1;
        };
        
        network = {
          format-wifi = "WiFi ({signalStrength}%)";
          format-ethernet = "ETH";
          format-disconnected = "DISCONNECTED";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        battery = {
          bat = "BAT0";
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTED";
          on-click = "pavucontrol";
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };
        
        "custom/launcher" = {
          format = "";
          on-click = "wofi --show drun";
          tooltip = false;
        };
        
        "custom/power" = {
          format = "";
          on-click = "wlogout";
          tooltip = false;
        };
      };
    };
  };

  # Basic home configuration version control
  home.stateVersion = "24.11";
}