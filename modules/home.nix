# Updated modules/home.nix with 2x scaling and QoL improvements

{ config, pkgs, hyprland, ... }:

{
  # Home Manager Configuration
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";
  
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
  
  # HYPRLAND CONFIGURATION with 2x scaling
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    
    extraConfig = ''
      # Monitor configuration with 2x scaling
      monitor=eDP-1,preferred,auto,2.0

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

      # General appearance for 2x scaling
      general {
        gaps_in = 8
        gaps_out = 16
        border_size = 3
        col.active_border = rgba(bd93f9ff) rgba(ff79c6ff) 45deg
        col.inactive_border = rgba(44475aff)
        layout = dwindle
      }

      # Decoration settings for 2x scaling
      decoration {
        rounding = 12
        blur {
          enabled = true
          size = 6
          passes = 2
        }
        drop_shadow = true
        shadow_range = 12
        shadow_render_power = 2
        col.shadow = rgba(00000044)
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

      # Environment variables for 2x scaling
      env = XCURSOR_THEME,Nordzy-cursors
      env = XCURSOR_SIZE,48
      env = WLR_NO_HARDWARE_CURSORS,1
      env = GDK_SCALE,2.0
      env = GDK_DPI_SCALE,0.5
      env = MOZ_ENABLE_WAYLAND,1
    '';
  };
  
  # TERMINAL CONFIGURATION for 2x scaling
  programs.kitty = {
    enable = true;
    theme = "Dracula";
    settings = {
      background_opacity = "0.95";
      font_family = "JetBrains Mono";
      font_size = 14;  # Increased for 2x scaling
      enable_audio_bell = false;
      window_padding_width = 16;  # Increased for 2x scaling
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
    };
  };
  
  # ZSH CONFIGURATION with better prompt
  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "history" "z" "fzf" ];
      theme = "robbyrussell";
    };
    
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -la";
      la = "ls -la";
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --upgrade";
      hm = "home-manager switch";
      hypr = "Hyprland";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
    };
    
    initExtra = ''
      # Better history
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS
      setopt SHARE_HISTORY
      
      # Auto-completion improvements
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      
      # Better directory navigation
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
    '';
  };

  # Starship prompt for better terminal experience
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        style = "bold cyan";
      };
      git_branch = {
        style = "bold purple";
      };
      git_status = {
        style = "bold yellow";
      };
    };
  };
  
  # VS CODE CONFIGURATION for 2x scaling
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
      "editor.fontSize" = 16;  # Increased for 2x scaling
      "editor.fontLigatures" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Dracula";
      "window.zoomLevel" = 1;  # Increased for 2x scaling
      "files.autoSave" = "afterDelay";
      "telemetry.telemetryLevel" = "off";
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.list.smoothScrolling" = true;
      "editor.smoothScrolling" = true;
    };
  };
  
  # GIT CONFIGURATION
  programs.git = {
    enable = true;
    userName = "dylan";
    userEmail = "dylan@permuy.me";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "vim";
    };
  };
  
  # Firefox with better settings for 2x scaling
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
        
        # UI scaling for 2x
        "layout.css.devPixelsPerPx" = "2.0";
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
  
  # WAYBAR CONFIGURATION for 2x scaling
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 16px;  /* Increased for 2x scaling */
        min-height: 0;
      }

      window#waybar {
        background: #282a36;
        color: #f8f8f2;
        border-bottom: 2px solid #44475a;
      }

      #workspaces button {
        padding: 0 16px;  /* Increased padding */
        background: #44475a;
        color: #f8f8f2;
        border-bottom: 4px solid transparent;  /* Thicker border */
      }

      #workspaces button.active {
        background: #bd93f9;
        border-bottom: 4px solid #ff79c6;
      }

      #mode, #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #idle_inhibitor, #custom-power, #custom-launcher {
        padding: 0 16px;  /* Increased padding */
        margin: 0 8px;    /* Increased margin */
        background: #44475a;
        color: #f8f8f2;
        border-radius: 8px;  /* Increased border radius */
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
        font-size: 18px;  /* Larger power button */
      }
      
      #custom-launcher {
        background: #50fa7b;
        color: #282a36;
        font-size: 18px;  /* Larger launcher button */
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;  # Increased height for 2x scaling

        modules-left = ["custom/launcher" "hyprland/workspaces" "hyprland/mode"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "cpu" "memory" "network" "battery" "tray" "custom/power"];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{name}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            default = "";
          };
        };

        clock = {
          format = "{:%a, %b %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = " {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = " {}%";
          interval = 2;
        };
        
        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = " ";
          format-disconnected = "⚠ ";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%): {ipaddr}";
          on-click = "nm-connection-editor";
        };

        battery = {
          bat = "BAT0";
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " ";
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
        };

        tray = {
          icon-size = 24;  # Increased for 2x scaling
          spacing = 16;    # Increased spacing
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

  # WOFI Configuration for 2x scaling
  programs.wofi = {
    enable = true;
    settings = {
      width = 800;      # Increased for 2x scaling
      height = 600;     # Increased for 2x scaling
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 48;  # Increased for 2x scaling
      gtk_dark = true;
    };
    
    style = ''
      window {
        margin: 0px;
        border: 3px solid #bd93f9;  /* Thicker border */
        background-color: #282a36;
        border-radius: 20px;        /* Larger border radius */
        font-size: 16px;            /* Larger font */
      }

      #input {
        margin: 8px;
        border: 3px solid #6272a4;
        background-color: #44475a;
        color: #f8f8f2;
        border-radius: 12px;
        padding: 12px;              /* More padding */
        font-size: 16px;
      }

      #inner-box {
        margin: 8px;
        background-color: #282a36;
        color: #f8f8f2;
        border-radius: 12px;
      }

      #outer-box {
        margin: 8px;
        padding: 16px;              /* More padding */
        background-color: #282a36;
        border-radius: 12px;
      }

      #scroll {
        margin: 8px;
        border: 2px solid #6272a4;
        background-color: #44475a;
        border-radius: 12px;
      }

      #text {
        margin: 8px;
        color: #f8f8f2;
        font-size: 14px;
      }

      #entry {
        padding: 8px;               /* More padding for entries */
      }

      #entry:selected {
        background-color: #44475a;
        border-radius: 12px;
      }

      #text:selected {
        color: #ff79c6;
      }
    '';
  };

  # Swaylock configuration for better security
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
      image = "~/.config/hypr/wallpaper.jpg";
      scaling = "fill";
    };
  };

  # Additional XDG configuration
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  # GTK configuration for 2x scaling
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
      size = 12;  # Good size for 2x scaling
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 48;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-theme-name = "Nordzy-cursors";
      gtk-cursor-theme-size = 48;
    };
  };

  # Qt configuration to match GTK
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # Services for better user experience
  services = {
    # Notification daemon
    swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        control-center-margin-top = 10;
        control-center-margin-bottom = 10;
        control-center-margin-right = 10;
        control-center-margin-left = 10;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 48;  # Larger for 2x scaling
        notification-body-image-height = 160;
        notification-body-image-width = 200;
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
        fit-to-screen = true;
        control-center-width = 500;  # Larger for 2x scaling
        control-center-height = 1000;
        notification-window-width = 400;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = false;
        hide-on-action = true;
        script-fail-notify = true;
      };
    };

    # Clipboard manager
    cliphist.enable = true;
  };

  # Basic home configuration version control
  home.stateVersion = "24.11";
}